@jboss-eap-7
Feature: EAP XP datasources with adjusted base config

Scenario: check datasource with default value used for default-job-repository does not give error when no batch-jberet subsystem
    When container is started with command bash
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
   Then run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
   And file /tmp/boot.log should not contain ERROR You have set the DEFAULT_JOB_REPOSITORY environment variables to configure a default-job-repository pointing to

Scenario: check datasource with specified value used for default-job-repository gives error when no batch-jberet subsystem
    When container is started with command bash
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
       | DEFAULT_JOB_REPOSITORY    | test-mysql                   |
   Then run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
   And file /tmp/boot.log should contain ERROR You have set the DEFAULT_JOB_REPOSITORY environment variables to configure a default-job-repository pointing to the 'test-mysql' datasource. Fix your configuration to contain a batch-jberet subsystem for this to happen.

Scenario: check datasource with default value used for timer-service-datastore does not give error when no ejb3 subsystem
    When container is started with command bash
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
   Then run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
   And file /tmp/boot.log should not contain ERROR You have set the TIMER_SERVICE_DATA_STORE environment variable which adds a timer-service to the ejb3 subsystem. Fix your configuration to contain an ejb3 subsystem for this to happen.

Scenario: check datasource with specified value used for timer-service-datastore gives error when no ejb3 subsystem
    When container is started with command bash
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
       | TIMER_SERVICE_DATA_STORE  | test-mysql                   |
   Then run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And file /tmp/boot.log should contain ERROR You have set the TIMER_SERVICE_DATA_STORE environment variable which adds a timer-service to the ejb3 subsystem. Fix your configuration to contain an ejb3 subsystem for this to happen.