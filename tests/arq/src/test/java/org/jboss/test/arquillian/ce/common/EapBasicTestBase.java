package org.jboss.test.arquillian.ce.common;

import java.net.URL;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.arquillian.cube.openshift.api.OpenShiftDynamicImageStreamResource;
import org.arquillian.cube.openshift.api.OpenShiftResource;
import org.arquillian.cube.openshift.impl.enricher.RouteURL;
import org.jboss.arquillian.container.test.api.RunAsClient;
import org.jboss.arquillian.junit.InSequence;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.junit.Test;

import static io.restassured.RestAssured.get;
import static io.restassured.RestAssured.given;
import static org.awaitility.Awaitility.with;
import static org.junit.Assert.assertEquals;

/**
 * @author Jonh Wendell
 * @author Marko Luksa
 */
@OpenShiftResource("${openshift.imageStreams}")
@OpenShiftDynamicImageStreamResource(name = "${image.stream.name}", image = "${image.stream.image}", version = "${image.stream.version}")
public class EapBasicTestBase {

    private static final int TIMEOUT_MINUTES = 10;
    private Logger log = Logger.getLogger(getClass().getName());
    @RouteURL("eap-app")
    private URL url;

    public EapBasicTestBase() {
        RestAssured.useRelaxedHTTPSValidation();
    }

    protected URL getUrl() {
        with().atMost(TIMEOUT_MINUTES, TimeUnit.MINUTES).pollInterval(5, TimeUnit.SECONDS).until(() -> {
            try {
                return get(url).getStatusCode() == 200;
            } catch (Exception e) {
                return false;
            }
        });

        return url;
    }

    @Test
    @RunAsClient
    @InSequence(1)
    public void testInitialState() throws Exception {
        log.info("Trying URL " + getUrl());

        Response response = get(getUrl() + "rest/members");

        JSONParser jsonParser = new JSONParser();
        JSONArray array = (JSONArray) jsonParser.parse(response.print());
        assertEquals(array.size(), 1);

        JSONObject remotePerson = getPerson(0);
        Person localPerson = new Person(0, "John Smith", "john.smith@mailinator.com", "2125551212");
        assertPeopleAreSame(remotePerson, localPerson);
    }

    @SuppressWarnings("unchecked")
    @Test
    @RunAsClient
    @InSequence(2)
    public void testCreatePerson() throws Exception {
        final String name = "ce-arq test for EAP";
        final String email = "cloud-enablement-feedback@redhat.com";
        final String phoneNumber = "555987654321";
        JSONObject p = new JSONObject();
        p.put("name", name);
        p.put("email", email);
        p.put("phoneNumber", phoneNumber);

        Response response = given().header("Content-Type", "application/json").body(p.toJSONString()).post(getUrl() + "rest/members");
        assertEquals(200, response.getStatusCode());

        JSONObject remotePerson = getPerson(1);
        Person localPerson = new Person(1, name, email, phoneNumber);
        assertPeopleAreSame(remotePerson, localPerson);
    }

    private JSONObject getPerson(int id) throws Exception {
        Response response = get(getUrl() + "rest/members/" + id);

        JSONParser jsonParser = new JSONParser();
        return (JSONObject) jsonParser.parse(response.print());
    }

    private void assertPeopleAreSame(JSONObject person1, Person person2) {
        assertEquals(person2.id, (long) person1.get("id"));
        assertEquals(person2.name, person1.get("name"));
        assertEquals(person2.email, person1.get("email"));
        assertEquals(person2.phoneNumber, person1.get("phoneNumber"));
    }

    private class Person {
        long id;
        String name;
        String email;
        String phoneNumber;

        Person(long id, String name, String email, String phoneNumber) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.phoneNumber = phoneNumber;
        }
    }
}
