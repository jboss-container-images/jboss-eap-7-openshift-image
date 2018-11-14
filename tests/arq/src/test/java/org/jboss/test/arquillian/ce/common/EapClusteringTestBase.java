package org.jboss.test.arquillian.ce.common;

import java.net.URL;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Logger;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.apache.commons.lang3.StringUtils;
import org.arquillian.cube.openshift.api.ConfigurationHandle;
import org.arquillian.cube.openshift.api.OpenShiftDynamicImageStreamResource;
import org.arquillian.cube.openshift.api.OpenShiftHandle;
import org.arquillian.cube.openshift.api.OpenShiftResource;
import org.arquillian.cube.openshift.impl.enricher.RouteURL;
import org.jboss.arquillian.container.test.api.RunAsClient;
import org.jboss.arquillian.junit.InSequence;
import org.jboss.arquillian.test.api.ArquillianResource;
import org.junit.Before;
import org.junit.Test;

import static io.restassured.RestAssured.get;
import static io.restassured.RestAssured.given;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * @author Jonh Wendell
 */
@OpenShiftResource("${openshift.imageStreams}")
@OpenShiftDynamicImageStreamResource(name = "${image.stream.name}", image = "${image.stream.image}", version = "${image.stream.version}")
public class EapClusteringTestBase {
    protected final Logger log = Logger.getLogger(getClass().getName());

    @ArquillianResource
    OpenShiftHandle adapter;

    @ArquillianResource
    ConfigurationHandle config;

    private String token;
    private List<String> pods;

    public EapClusteringTestBase() {
        RestAssured.useRelaxedHTTPSValidation();
    }

    @Before
    public void setup() throws Exception {
        token = config.getToken();
        assertFalse("Auth token must be provided", token == null || token.isEmpty());
    }

    /**
     * This test starts two pods; insert a value into the first pod's session.
     * Then it retrieves this value from the second pod.
     * <p>
     * After that it starts a third pod and try to get the value from it, to see
     * if session replication is working at pod's startup as well.
     *
     * @throws Exception
     */
    @Test
    @RunAsClient
    @InSequence(1)
    public void testSession() throws Exception {
        // Start with 2 pods
        scale(2);

        final String valueToCheck = UUID.randomUUID().toString();

        // Insert a session value into the first pod
        String servletUrl = buildURL(pods.get(0));
        // Note, pods.get() / buildURL can return urls that look like http://foo/bar//baz and the double
        // slash causes requests to fail, as it becomes encoded as %2F, so filter those.
        servletUrl = sanitizeUrl(servletUrl);

        System.out.println("ServletURL: " + servletUrl);

        Map<String, String> params = new HashMap<>();
        params.put("key", valueToCheck);
        Response response = given().header("Authorization", "Bearer " + token).params(params).post(servletUrl);

        System.out.println("Response: " + response.asString());
        assertEquals(servletUrl + "(Authorization: Bearer " + token +")", "OK", response.getBody().asString());

        String cookie = response.getHeader("Set-Cookie");
        System.out.println("Cookie: " + cookie);

        // Retrieve the value from the second pod
        assertEquals(servletUrl, valueToCheck, retrieveKey(1, cookie));

        // Now start a third shiny new pod and retrieve the value from it
        scale(3);
        assertEquals(servletUrl, valueToCheck, retrieveKey(2, cookie));
    }

    /**
     * This test does the same as {@link #testSession()}, however it redeploys
     * the app with environment variables "http_proxy" and "https_proxy". Those
     * should not interfere in the EAP clustering.
     *
     * @throws Exception
     */
    @Test
    @RunAsClient
    @InSequence(2)
    public void testSessionWithProxy() throws Exception {
        scale(1);

        Map<String, String> variables = new HashMap<>();
        variables.put("http_proxy", "1.2.3.4");
        variables.put("https_proxy", "4.3.2.1");
        adapter.triggerDeploymentConfigUpdate("eap-app", true, variables);

        testSession();
    }

    protected void scale(int replicas) throws Exception {
        System.out.println("Scaling to: " + replicas);
        adapter.scaleDeployment("eap-app", replicas);
        pods = getPods();
        dumpPods();
    }

    private void dumpPods() {
        System.out.println("Total Pods: " + pods.size());
        for (String s : pods) {
            System.out.println("Pod: " + s);
        }
    }

    private String retrieveKey(int podIndex, String cookie) throws Exception {
        String servletUrl = buildURL(pods.get(podIndex));
        servletUrl=sanitizeUrl(servletUrl);
        System.out.println("RetrieveURL: " + servletUrl);
        Response response = given().header("Authorization", "Bearer " + token).header("Cookie", cookie).get(servletUrl);

        return response.getBody().asString();
    }

    private List<String> getPods() throws Exception {
        final List<String> pods = adapter.getPods();
        pods.removeIf((String s) -> (s.endsWith("-build") || !s.startsWith("eap-app-")));
        return pods;
    }

    private String buildURL(String podName) {
        return adapter.url(podName, 8080, "/cluster1/StoreInSession", null);
    }

    private String sanitizeUrl(final String url) {
        if (url != null) {
            return url.replaceAll("(?<!(http:|https:))//", "/");
        }
        return null;
    }
    /**
     * This test starts with a high number of pods. We do lots of HTTP requests
     * sequentially, with a delay of 1 second between them.
     * <p>
     * In parallel, after every N requests we scale down the cluster by 1 pod.
     * This happens in another thread and continues until we reach only one pod
     * in activity.
     * <p>
     * The HTTP requests must continue to work correctly, as the openshift
     * router should redirect them to any working pod.
     *
     * @param url route url
     * @throws Exception
     */
    @Test
    @RunAsClient
    public void testAppStillWorksWhenScalingDown(@RouteURL("eap-app") URL url) throws Exception {
        // Number of HTTP requests we are going to do
        final int REQUESTS = 100;
        // Initial number of replicas, will decrease over time until 1
        final int REPLICAS = 5;
        // Decrement the number of replicas on each STEP requests
        final int STEP = REQUESTS / REPLICAS;

        // Setup initial state
        int replicas = REPLICAS;
        adapter.scaleDeployment("eap-app", replicas);

        // Do the requests
        for (int i = 1; i <= REQUESTS; i++) {
            Response response = get(url.toString() + "cluster1/Hi");
            assertEquals(url.toString() + "cluster1/Hi", 200, response.getStatusCode());

            String body = response.getBody().asString();
            log.info(String.format("Try %d -  GOT: %s", i, body));
            assertTrue(body.startsWith("Served from node: "));

            if (i % STEP == 0 && replicas > 1) {
                replicas--;
                (new ScaleTo(replicas)).start();
            }

            Thread.sleep(1000);
        }
    }

    protected int doDelayRequest(String url, int seconds) throws Exception {
        Response response = get(url + "/cluster1/Hi");

        String body = response.getBody().asString();
        assertTrue("Got an invalid response: " + body, body.startsWith("Served from node: "));
        log.info(String.format("HI - BODY = %s", body));

        String podName = getHostName(body);


        (new DeletePod(podName)).start();
        log.info(String.format("About to request DELAY with %d seconds", seconds));
        response = get(String.format("%s/cluster1/Delay?d=%d", url, seconds));
        body = response.getBody().asString();
        int stars = StringUtils.countMatches(body, "*");
        log.info(String.format("DELAY - BODY = %s", body));
        return stars;
    }

    private String getHostName(String body) {
        String parts1[] = body.split(": ");
        String parts2[] = parts1[1].split("/");
        return parts2[0];
    }

    private class DeletePod extends Thread {
        String podName;
        int initialDelay;

        public DeletePod(String podName, int initialDelay) {
            log.info(String.format("DeletePod created with name %s. Waiting %d secs to start deleting.%n", podName, initialDelay));
            this.podName = podName;
            this.initialDelay = initialDelay;
        }

        public DeletePod(String podName) {
            this(podName, 5);
        }

        @Override
        public void run() {
            try {
                Thread.sleep(initialDelay * 1000);
                log.info("Now deleting " + podName);
                adapter.deletePod(podName, -1); // use default grace period?
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private class ScaleTo extends Thread {
        int r;

        public ScaleTo(int r) {
            log.info(String.format("ScaleTo created with %d replicas%n", r));
            this.r = r;
        }

        @Override
        public void run() {
            try {
                adapter.scaleDeployment("eap-app", r);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
