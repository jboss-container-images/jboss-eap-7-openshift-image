@jboss-eap-7 
Feature: EAP XP security domains

  Scenario: check Elytron configuration with elytron core realms security domain fail
    Given s2i build https://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-web-security with env and true
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
     Then container log should contain WFLYSRV0025
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
     And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |

  Scenario: check Elytron configuration with elytron custom security domain fail
    Given s2i build https://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-web-security with env and true using master without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | empty-foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | empty-foo-roles.properties                 |
    When container integ- is started with command bash
    Then copy features/jboss-eap-modules/scripts/security_domains/empty-foo-users.properties to /opt/eap/standalone/configuration/ in container    
    Then copy features/jboss-eap-modules/scripts/security_domains/empty-foo-roles.properties to /opt/eap/standalone/configuration/ in container    
    And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain

