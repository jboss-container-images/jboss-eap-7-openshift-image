@jboss-eap-7
Feature: EAP XP admin

  Scenario: Standard configuration
    When container is started with env
       | variable       | value           |
       | ADMIN_USERNAME | kabir           |
       | ADMIN_PASSWORD | pass            |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value management-http-authentication on XPath //*[local-name()='http-interface']/@http-authentication-factory
    And file /opt/eap/standalone/configuration/mgmt-users.properties should contain kabir
