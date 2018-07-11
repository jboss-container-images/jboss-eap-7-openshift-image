package org.jboss.test.arquillian.ce.eap71;

import org.arquillian.cube.openshift.api.OpenShiftResource;
import org.arquillian.cube.openshift.api.Template;
import org.arquillian.cube.openshift.api.TemplateParameter;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.test.arquillian.ce.common.EapClusteringTestBase;
import org.junit.Ignore;
import org.junit.runner.RunWith;

/**
 * @author Jonh Wendell
 */
@RunWith(Arquillian.class)
@Template(url = "https://raw.githubusercontent.com/${template.repository:jboss-openshift}/application-templates/${template.branch:master}/eap/eap71-basic-s2i.json", parameters = {
        @TemplateParameter(name = "SOURCE_REPOSITORY_URL", value = "https://github.com/jboss-openshift/openshift-examples"),
        @TemplateParameter(name = "SOURCE_REPOSITORY_REF", value = "master"),
        @TemplateParameter(name = "CONTEXT_DIR", value = "eap-tests/cluster1") })
@OpenShiftResource("https://raw.githubusercontent.com/${template.repository:jboss-openshift}/application-templates/${template.branch:master}/secrets/eap7-app-secret.json")
// TODO Check RoleBindings annotation requirement
//@RoleBindings({
//        @RoleBinding(roleRefName = "view", userName = "system:serviceaccount:${kubernetes.namespace}:default"),
//        @RoleBinding(roleRefName = "view", userName = "system:serviceaccount:${kubernetes.namespace}:eap7-service-account") })
@Ignore("RoleBindings annotation needs investigation on why it is not available in Arquillian Cube and if it required to run the test")
public class Eap71ClusteringTest extends EapClusteringTestBase {
}
