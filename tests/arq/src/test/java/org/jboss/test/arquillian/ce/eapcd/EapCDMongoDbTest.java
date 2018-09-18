package org.jboss.test.arquillian.ce.eapcd;

import org.arquillian.cube.openshift.api.OpenShiftResource;
import org.arquillian.cube.openshift.api.Template;
import org.arquillian.cube.openshift.api.TemplateParameter;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.test.arquillian.ce.common.EapDbTestBase;
import org.junit.runner.RunWith;

/**
 * @author Marko Luksa
 */
@RunWith(Arquillian.class)
@Template(url = "${template.uri}/eap-cd-mongodb-s2i.json", parameters = {
        @TemplateParameter(name = "IMAGE_STREAM_NAMESPACE", value = "${kubernetes.namespace:openshift}"),
        @TemplateParameter(name = "HTTPS_NAME", value = "jboss"),
        @TemplateParameter(name = "HTTPS_PASSWORD", value = "mykeystorepass")})
@OpenShiftResource("https://raw.githubusercontent.com/${secrets.repository:jboss-openshift}/application-templates/${secrets.branch:master}/secrets/eap7-app-secret.json")
public class EapCDMongoDbTest extends EapDbTestBase {
}
