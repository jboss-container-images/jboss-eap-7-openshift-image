@jboss-eap-7-tech-preview
Feature: OpenShift EAP SSO tests

  Scenario: Check custom keycloak config
     Given s2i build https://github.com/redhat-developer/redhat-sso-quickstarts using 7.0.x-ose
       | variable               | value                                                                     |
       | ARTIFACT_DIR           | app-jee-jsp/target,service-jee-jaxrs/target,app-profile-jee-jsp/target,app-profile-saml-jee-jsp/target    |
       | SSO_REALM              | demo                                                                      |
       | SSO_PUBLIC_KEY         | MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiLezsNQtZSaJvNZXTmjhlpIJnnwgGL5R1vkPLdt7odMgDzLHQ1h4DlfJPuPI4aI8uo8VkSGYQXWaOGUh3YJXtdO1vcym1SuP8ep6YnDy9vbUibA/o8RW6Wnj3Y4tqShIfuWf3MEsiH+KizoIJm6Av7DTGZSGFQnZWxBEZ2WUyFt297aLWuVM0k9vHMWSraXQo78XuU3pxrYzkI+A4QpeShg8xE7mNrs8g3uTmc53KR45+wW1icclzdix/JcT6YaSgLEVrIR9WkkYfEGj3vSrOzYA46pQe6WQoenLKtIDFmFDPjhcPoi989px9f+1HCIYP0txBS/hnJZaPdn5/lEUKQIDAQAB  |
       | SSO_URL                | http://localhost:8080/auth    |
       | SSO_ENABLE_CORS        | true                          |
       | SSO_BEARER_ONLY        | true                          |
       | SSO_SAML_LOGOUT_PAGE   | /tombrady                     |
       | MAVEN_ARGS_APPEND      | -Dmaven.compiler.source=1.6 -Dmaven.compiler.target=1.6 |
    Then container log should contain Deployed "service.war"
    And container log should contain Deployed "app-profile-jsp.war"
    And container log should contain Deployed "app-jsp.war"
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value demo on XPath //*[local-name()='realm']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value app-jsp.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-jsp.war"]/*[local-name()='enable-cors']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-jsp.war"]/*[local-name()='bearer-only']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-jsp.war"]/*[local-name()='enable-basic-auth'] 
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value http://localhost:8080/auth on XPath //*[local-name()='secure-deployment'][@name="app-jsp.war"]/*[local-name()='auth-server-url']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value app-profile-jsp.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value service.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value app-profile-saml.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value app-profile-saml on XPath //*[local-name()='secure-deployment'][@name="app-profile-saml.war"]/*[local-name()='SP']/@entityID
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value EXTERNAL on XPath //*[local-name()='secure-deployment'][@name="app-profile-saml.war"]/*[local-name()='SP']/@sslPolicy
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value /tombrady on XPath //*[local-name()='secure-deployment'][@name="app-profile-saml.war"]/*[local-name()='SP']/@logoutPage       
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-profile-saml.war"]/*[local-name()='SP']/*[local-name()='Keys']/*[local-name()='Key']/@signing 
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value idp on XPath //*[local-name()='secure-deployment'][@name="app-profile-saml.war"]/*[local-name()='SP']/*[local-name()='IDP']/@entityID 
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 0 elements on XPath //*[local-name()='application-security-domain']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value keycloak on XPath //*[local-name()='security-domain']/@name

  Scenario: SSO, ejb3 app sec domain already exists should give error
    Given s2i build https://github.com/redhat-developer/redhat-sso-quickstarts from . with env and true using 7.0.x-ose without running
       | variable                   | value         |
       | ARTIFACT_DIR           | app-jee-jsp/target,app-profile-jee-jsp/target |
       | SSO_REALM         | demo    |
       | SSO_PUBLIC_KEY    | MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiLezsNQtZSaJvNZXTmjhlpIJnnwgGL5R1vkPLdt7odMgDzLHQ1h4DlfJPuPI4aI8uo8VkSGYQXWaOGUh3YJXtdO1vcym1SuP8ep6YnDy9vbUibA/o8RW6Wnj3Y4tqShIfuWf3MEsiH+KizoIJm6Av7DTGZSGFQnZWxBEZ2WUyFt297aLWuVM0k9vHMWSraXQo78XuU3pxrYzkI+A4QpeShg8xE7mNrs8g3uTmc53KR45+wW1icclzdix/JcT6YaSgLEVrIR9WkkYfEGj3vSrOzYA46pQe6WQoenLKtIDFmFDPjhcPoi989px9f+1HCIYP0txBS/hnJZaPdn5/lEUKQIDAQAB  |
       | SSO_URL           | http://localhost:8080/auth    |
       | MAVEN_ARGS_APPEND | -Dmaven.compiler.source=1.6 -Dmaven.compiler.target=1.6 |
       | SSO_FORCE_LEGACY_SECURITY   | false                     |
    When container integ- is started with command bash
    Then copy features/jboss-eap-modules/scripts/sso/add-ejb3-sec-domain.cli to /tmp in container
    And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-ejb3-sec-domain.cli in container once
    And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
    And file /tmp/boot.log should contain ejb3 already contains keycloak application security domain. Fix your configuration or set SSO_SECURITY_DOMAIN env variable.
