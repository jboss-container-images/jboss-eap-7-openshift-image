@jboss-eap-7-tech-preview
Feature: EAP Openshift security domains

  Scenario: check security-domain configured
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env
       | variable           | value       |
       | SECDOMAIN_NAME | HiThere     |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='rolesProperties'][@value='${jboss.server.config.dir}/roles.properties']

  Scenario: check security-domain custom user properties
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env
       | variable                        | value                 |
       | SECDOMAIN_NAME              | HiThere               |
       | SECDOMAIN_USERS_PROPERTIES  | otherusers.properties |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='usersProperties'][@value='${jboss.server.config.dir}/otherusers.properties']

  Scenario: check security-domain custom role properties
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env
       | variable                        | value                 |
       | SECDOMAIN_NAME              | HiThere               |
       | SECDOMAIN_ROLES_PROPERTIES  | otherroles.properties |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='rolesProperties'][@value='${jboss.server.config.dir}/otherroles.properties']

  # CLOUD-431
  Scenario: check security-domain custom role and user properties specified as absolute path
    When container is started with env
       | variable                        | value                 |
       | SECDOMAIN_NAME              | HiThere                   |
       | SECDOMAIN_ROLES_PROPERTIES  | /opt/eap/standalone/configuration/application-roles.properties |
       | SECDOMAIN_USERS_PROPERTIES  | /opt/eap/standalone/configuration/application-users.properties |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value /opt/eap/standalone/configuration/application-roles.properties on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='rolesProperties']/@value
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value /opt/eap/standalone/configuration/application-users.properties on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='usersProperties']/@value

  Scenario: check security-domain classic login module
    When container is started with env
      | variable                        | value                        |
      | SECDOMAIN_NAME                  | jdg-openshift                |
      | SECDOMAIN_USERS_PROPERTIES      | application-users.properties |
      | SECDOMAIN_ROLES_PROPERTIES      | application-roles.properties |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value UsersRoles on XPath //*[local-name()='security-domain'][@name='jdg-openshift']//*[local-name()='login-module']/@code

  Scenario: check security-domain realm login module
    When container is started with env
      | variable                        | value                        |
      | SECDOMAIN_NAME                  | jdg-openshift                |
      | SECDOMAIN_LOGIN_MODULE          | RealmUsersRoles              |
      | SECDOMAIN_USERS_PROPERTIES      | application-users.properties |
      | SECDOMAIN_ROLES_PROPERTIES      | application-roles.properties |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value RealmUsersRoles on XPath //*[local-name()='security-domain'][@name='jdg-openshift']//*[local-name()='login-module']/@code
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ApplicationRealm on XPath //*[local-name()='security-domain'][@name='jdg-openshift']//*[local-name()='login-module']/*[local-name()='module-option'][@name='realm']/@value

  Scenario: check security-domain configured with prefix
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env
       | variable           | value       |
       | EAP_SECDOMAIN_NAME | HiThere     |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='rolesProperties'][@value='${jboss.server.config.dir}/roles.properties']

  Scenario: check security-domain custom user properties with prefix
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env
       | variable                        | value                 |
       | EAP_SECDOMAIN_NAME              | HiThere               |
       | EAP_SECDOMAIN_USERS_PROPERTIES  | otherusers.properties |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='usersProperties'][@value='${jboss.server.config.dir}/otherusers.properties']

  Scenario: check security-domain custom role properties with prefix
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env
       | variable                        | value                 |
       | EAP_SECDOMAIN_NAME              | HiThere               |
       | EAP_SECDOMAIN_ROLES_PROPERTIES  | otherroles.properties |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='security-domain'][@name='HiThere'][@cache-type='default']/*[local-name()='authentication']/*[local-name()='login-module']/*[local-name()='module-option'][@name='rolesProperties'][@value='${jboss.server.config.dir}/otherroles.properties']
  
  Scenario: check Elytron configuration
    Given s2i build https://github.com/jboss-openshift/openshift-examples from security-custom-configuration with env and true using master
       | variable           | value       |
       | SECDOMAIN_NAME     | application-security     |
     Then container log should contain Running jboss-eap-
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security on XPath //*[local-name()='elytron-integration']/*[local-name()='security-realms']/*[local-name()='elytron-realm']/@name
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security on XPath //*[local-name()='elytron-integration']/*[local-name()='security-realms']/*[local-name()='elytron-realm']/@legacy-jaas-config
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security-http on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@http-authentication-factory
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value BASIC on XPath //*[local-name()='http-authentication-factory'][@name='application-security-http'][@security-domain='application-security']/*[local-name()='mechanism-configuration']/*[local-name()='mechanism'][1]/@mechanism-name
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value FORM on XPath //*[local-name()='http-authentication-factory'][@name='application-security-http'][@security-domain='application-security']/*[local-name()='mechanism-configuration']/*[local-name()='mechanism'][2]/@mechanism-name
      And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value application-security on XPath //*[local-name()='security-domain'][@name='application-security'][@default-realm='application-security']/*[local-name()='realm']/@name

  Scenario: check other login modules
    Given s2i build git://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-extension with env and true
    Then container log should contain WFLYSRV0025
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value org.kie.security.jaas.KieLoginModule on XPath //*[local-name()='login-module']/@code
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value optional on XPath //*[local-name()='login-module' and @code="org.kie.security.jaas.KieLoginModule"]/@flag
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value deployment.ROOT.war on XPath //*[local-name()='login-module'][@code="org.kie.security.jaas.KieLoginModule"]/@module

  Scenario: check other login modules, galleon
    Given s2i build git://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-extension with env and true
      | variable                     | value       |
      | GALLEON_PROVISION_SERVER     | slim-default-server     |
    Then container log should contain WFLYSRV0025
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value org.kie.security.jaas.KieLoginModule on XPath //*[local-name()='login-module']/@code
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value optional on XPath //*[local-name()='login-module' and @code="org.kie.security.jaas.KieLoginModule"]/@flag
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value deployment.ROOT.war on XPath //*[local-name()='login-module'][@code="org.kie.security.jaas.KieLoginModule"]/@module

  Scenario: check Elytron configuration with elytron core realms security domain fail
    Given s2i build https://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-web-security with env and true
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
     Then container log should contain WFLYSRV0025
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
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
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
