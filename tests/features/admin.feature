@jboss-eap-7
Feature: EAP Openshift admin

  Scenario: Standard configuration
    When container is started with env
       | variable       | value           |
       | ADMIN_USERNAME | kabir           |
       | ADMIN_PASSWORD | pass            |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ManagementRealm on XPath //*[local-name()='http-interface']/@security-realm
    And file /opt/eap/standalone/configuration/mgmt-users.properties should contain kabir

  Scenario: check management realm extension
    Given s2i build git://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-extension with env and true
    Then container log should contain WFLYSRV0025
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ApplicationRealm on XPath  //*[local-name()='http-interface']/@security-realm
