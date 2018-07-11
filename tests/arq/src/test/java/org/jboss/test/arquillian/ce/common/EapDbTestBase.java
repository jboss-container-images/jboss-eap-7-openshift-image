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
@OpenShiftDynamicImageStreamResource(name = "${imageStream.eap71.name:jboss-eap71-openshift}", image = "${imageStream.eap71.image:registry.access.redhat.com/jboss-eap-7/eap71-openshift:1.3}", version = "${imageStream.eap71.version:1.3}")
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
