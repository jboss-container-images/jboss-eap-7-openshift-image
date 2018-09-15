package org.jboss.test.arquillian.ce.common;

import java.net.URL;

import org.arquillian.cube.openshift.impl.enricher.RouteURL;

/**
 * @author Jonh Wendell
 * @author Marko Luksa
 */
public class EapHttpsTestBase extends EapBasicTestBase {

    @RouteURL("secure-eap-app")
    private URL url;

    protected URL getUrl() {
        return url;
    }
}
