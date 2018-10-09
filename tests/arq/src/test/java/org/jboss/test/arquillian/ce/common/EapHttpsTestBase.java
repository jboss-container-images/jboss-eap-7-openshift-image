package org.jboss.test.arquillian.ce.common;

import java.net.URL;
import org.arquillian.cube.openshift.api.OpenShiftDynamicImageStreamResource;
import org.arquillian.cube.openshift.api.OpenShiftResource;
import org.arquillian.cube.openshift.impl.enricher.RouteURL;

/**
 * @author Jonh Wendell
 * @author Marko Luksa
 */
@OpenShiftResource("${openshift.imageStreams}")
@OpenShiftDynamicImageStreamResource(name = "${image.stream.name}", image = "${image.stream.image}", version = "${image.stream.version}")
public class EapHttpsTestBase extends EapBasicTestBase {

    @RouteURL("secure-eap-app")
    private URL url;
}