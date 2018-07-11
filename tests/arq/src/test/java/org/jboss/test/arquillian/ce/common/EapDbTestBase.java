package org.jboss.test.arquillian.ce.common;

import java.net.URL;

import org.arquillian.cube.openshift.impl.enricher.RouteURL;
import org.jboss.arquillian.container.test.api.RunAsClient;
import org.junit.Test;

/**
 * @author Jonh Wendell
 * @author Marko Luksa
 */
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
