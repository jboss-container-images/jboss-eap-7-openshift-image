@jboss-eap-7
Feature: EAP XP datasources

  Scenario: check mysql datasource
    When container is started with env
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='xa-datasource']/@jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 10.1.1.1 on XPath //*[local-name()='xa-datasource-property'][@name="ServerName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 3306 on XPath //*[local-name()='xa-datasource-property'][@name="Port"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value kitchensink on XPath //*[local-name()='xa-datasource-property'][@name="DatabaseName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value marek on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='user-name']
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value hardtoguess on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='password']
    # Check defaults in other affected subsystems
    # We will not do these extra checks for the everywhere (just once for each kind of ds), but will have other tests where we set them.
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should not contain WARN The default datasource for the ee subsystem has been guessed to be

  Scenario: check postgresql datasource
    When container is started with env
       | variable                  | value                            |
       | DB_SERVICE_PREFIX_MAPPING     | test-postgresql=TEST         |
       | TEST_DATABASE                 | kitchensink                  |
       | TEST_USERNAME                 | marek                        |
       | TEST_PASSWORD                 | hardtoguess                  |
       | TEST_POSTGRESQL_SERVICE_HOST  | 10.1.1.1                     |
       | TEST_POSTGRESQL_SERVICE_PORT  | 5432                         |
       | JDBC_SKIP_RECOVERY            | true                         |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='xa-datasource']/@jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 10.1.1.1 on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="ServerName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 5432 on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="PortNumber"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value kitchensink on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="DatabaseName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value marek on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='user-name']
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value hardtoguess on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='password']
    # Check defaults in other affected subsystems
    # We will not do these extra checks for the everywhere (just once for each kind of ds), but will have other tests where we set them.
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should not contain WARN The default datasource for the ee subsystem has been guessed to be

  Scenario: check mysql and postgresql datasource
    When container is started with env
       | variable                      | value                                                  |
       | DB_SERVICE_PREFIX_MAPPING     | test-postgresql=TEST_POSTGRESQL,test-mysql=TEST_MYSQL  |
       | TEST_MYSQL_DATABASE           | kitchensink-m                                          |
       | TEST_MYSQL_USERNAME           | marek-m                                                |
       | TEST_MYSQL_PASSWORD           | hardtoguess-m                                          |
       | TEST_MYSQL_SERVICE_HOST       | 10.1.1.1                                               |
       | TEST_MYSQL_SERVICE_PORT       | 3306                                                   |
       | TEST_POSTGRESQL_DATABASE      | kitchensink-p                                          |
       | TEST_POSTGRESQL_USERNAME      | marek-p                                                |
       | TEST_POSTGRESQL_PASSWORD      | hardtoguess-p                                          |
       | TEST_POSTGRESQL_SERVICE_HOST  | 10.1.1.2                                               |
       | TEST_POSTGRESQL_SERVICE_PORT  | 5432                                                   |
       | JDBC_SKIP_RECOVERY            | true                                                   |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='xa-datasource']/@jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL on XPath //*[local-name()='xa-datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 10.1.1.1 on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="ServerName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 5432 on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="PortNumber"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value kitchensink-p on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="DatabaseName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value marek-p on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='user-name']
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value hardtoguess-p on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='password']
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='xa-datasource']/@jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL on XPath //*[local-name()='xa-datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 10.1.1.2 on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="ServerName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value 3306 on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="Port"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain trimmed value kitchensink-m on XPath //*[local-name()='xa-datasource']/*[local-name()='xa-datasource-property'][@name="DatabaseName"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value marek-m on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='user-name']
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value hardtoguess-m on XPath //*[local-name()='xa-datasource']/*[local-name()='security']/*[local-name()='password']
    # Check defaults in other affected subsystems
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should contain WARN The default datasource for the ee subsystem has been guessed to be java:jboss/datasources/test_postgresql. Specify this using EE_DEFAULT_DATASOURCE
