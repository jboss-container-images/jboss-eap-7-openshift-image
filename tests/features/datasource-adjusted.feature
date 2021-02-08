@jboss-eap-7-tech-preview
Feature: EAP Openshift datasources with adjusted base config

# This does tests where we modify the base configuration before we try to start the container

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
   Then copy features/jboss-eap-modules/scripts/datasource/remove-batch-jberet-subsystem.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/remove-batch-jberet-subsystem.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
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
   Then copy features/jboss-eap-modules/scripts/datasource/remove-batch-jberet-subsystem.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/remove-batch-jberet-subsystem.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
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
   Then copy features/jboss-eap-modules/scripts/datasource/remove-ejb3-subsystem.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/remove-ejb3-subsystem.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
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
   Then copy features/jboss-eap-modules/scripts/datasource/remove-ejb3-subsystem.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/remove-ejb3-subsystem.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And file /tmp/boot.log should contain ERROR You have set the TIMER_SERVICE_DATA_STORE environment variable which adds a timer-service to the ejb3 subsystem. Fix your configuration to contain an ejb3 subsystem for this to happen.

Scenario: check datasource existing timer-service database-data-store not changed when not specified
    When container is started with command bash
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
   Then copy features/jboss-eap-modules/scripts/datasource/add-standard-base-datasources.cli to /tmp in container
   And copy features/jboss-eap-modules/scripts/datasource/add-standard-base-timer-service.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-standard-base-datasources.cli in container once
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-standard-base-timer-service.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
   # Skip a lot of the checks done in 'check mysql datasource' anyway
   # Now for what we are after....
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='database-data-store'] and wait 30 seconds
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-B_ds on XPath //*[local-name()='timer-service']/@default-data-store
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-B_ds on XPath //*[local-name()='database-data-store']/@name
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_b on XPath //*[local-name()='database-data-store']/@datasource-jndi-name
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value mysql on XPath //*[local-name()='database-data-store']/@database
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_b-TEST_part on XPath //*[local-name()='database-data-store']/@partition

Scenario: check datasource and set timer-service when a database-data-store already exists with a different name
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
   Then copy features/jboss-eap-modules/scripts/datasource/add-standard-base-datasources.cli to /tmp in container
   And copy features/jboss-eap-modules/scripts/datasource/add-standard-base-timer-service.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-standard-base-datasources.cli in container once
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-standard-base-timer-service.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
   # Skip a lot of the checks done in 'check mysql datasource' anyway
   # Now for what we are after....
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 2 elements on XPath //*[local-name()='database-data-store'] and wait 30 seconds
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_ds on XPath //*[local-name()='timer-service']/@default-data-store
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-B_ds on XPath //*[local-name()='database-data-store']/@name
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_ds on XPath //*[local-name()='database-data-store']/@name
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='database-data-store'][@name='test_mysql-TEST_ds']/@datasource-jndi-name
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value mysql on XPath //*[local-name()='database-data-store'][@name='test_mysql-TEST_ds']/@database
   And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_part on XPath //*[local-name()='database-data-store'][@name='test_mysql-TEST_ds']/@partition

Scenario: check datasource and timer service with a clashing database-data-store name gives error
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
   Then copy features/jboss-eap-modules/scripts/datasource/add-standard-base-datasources.cli to /tmp in container
   And copy features/jboss-eap-modules/scripts/datasource/add-clashing-base-timer-service.cli to /tmp in container
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-standard-base-datasources.cli in container once
   And run /opt/eap/bin/jboss-cli.sh --file=/tmp/add-clashing-base-timer-service.cli in container once
   And run script -c /opt/eap/bin/openshift-launch.sh /tmp/boot.log in container and detach
   # Skip a lot of the checks done in 'check mysql datasource' anyway
   # Now for what we are after....
   And file /tmp/boot.log should contain ERROR You have set environment variables to configure a timer service database-data-store in the ejb3 subsystem which conflict with the values that already exist in the base configuration. Fix your configuration.
