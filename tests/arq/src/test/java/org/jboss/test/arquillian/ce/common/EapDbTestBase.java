package org.jboss.test.arquillian.ce.common;

import java.net.URL;
import org.arquillian.cube.openshift.api.OpenShiftDynamicImageStreamResource;
import org.arquillian.cube.openshift.api.OpenShiftResource;
import org.arquillian.cube.openshift.impl.enricher.RouteURL;
import org.jboss.arquillian.container.test.api.RunAsClient;
import org.junit.Test;

/**
 * @author Jonh Wendell
 * @author Marko Luksa
 */
@OpenShiftResource("${openshift.imageStreams}")
@OpenShiftDynamicImageStreamResource(name = "${image.stream.name}", image = "${image.stream.image}", version = "${image.stream.version}")
public abstract class EapDbTestBase {
    @RouteURL("eap-app")
    private URL url;

    @RouteURL("secure-eap-app")
    private URL secureUrl;

    @Test
    @RunAsClient
    public void testTodoList() throws Exception {
        TodoList.insertItem(url.toString());
        TodoList.insertItem(secureUrl.toString());
    }
}
