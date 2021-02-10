@jboss-eap-7-tech-preview
Feature: EAP Openshift datasources

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
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='file-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value timer-service-data on XPath //*[local-name()='file-data-store']/@path
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value jboss.server.data.dir on XPath //*[local-name()='file-data-store']/@relative-to
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value in-memory on XPath //*[local-name()='default-job-repository']/@name
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should not contain WARN The default datasource for the ee subsystem has been guessed to be

  # https://issues.jboss.org/browse/CLOUD-508
  Scenario: check default for timer service datastore
    When container is ready
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='file-data-store']/@name
     And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='timer-service']/*[local-name()='data-stores'] and wait 30 seconds

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
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='file-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value timer-service-data on XPath //*[local-name()='file-data-store']/@path
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value jboss.server.data.dir on XPath //*[local-name()='file-data-store']/@relative-to
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value in-memory on XPath //*[local-name()='default-job-repository']/@name
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
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value default-file-store on XPath //*[local-name()='file-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value timer-service-data on XPath //*[local-name()='file-data-store']/@path
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value jboss.server.data.dir on XPath //*[local-name()='file-data-store']/@relative-to
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value in-memory on XPath //*[local-name()='default-job-repository']/@name
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should contain WARN The default datasource for the ee subsystem has been guessed to be java:jboss/datasources/test_postgresql. Specify this using EE_DEFAULT_DATASOURCE

  Scenario: check that exampleDS is generated by default if enabled (CLOUD-7)
    #wildfly-cekit-modules has been updated to only add this if ENABLE_GENERATE_DEFAULT_DATASOURCE=true
    When container is started with env
       | variable                      | value                |
       | TIMER_SERVICE_DATA_STORE      | ExampleDS            |
       | ENABLE_GENERATE_DEFAULT_DATASOURCE | true            |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/ExampleDS on XPath //*[local-name()='datasource']/@jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ExampleDS on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ExampleDS_ds on XPath //*[local-name()='database-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/ExampleDS on XPath //*[local-name()='database-data-store']/@datasource-jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value hsql on XPath //*[local-name()='database-data-store']/@database
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value ExampleDS_part on XPath //*[local-name()='database-data-store']/@partition
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath //*[local-name()='datasource'] and wait 30 seconds
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/ExampleDS on XPath //*[local-name()='default-bindings']/@datasource
    And container log should not contain WARN The default datasource for the ee subsystem has been guessed to be

  Scenario: CLOUD-2068, test timer datasource refresh-interval
    When container is started with env
      | variable                                  | value                                  |
      | DATASOURCES                               | TEST                                   |
      | TEST_JNDI                                 | java:/jboss/datasources/testds         |
      | TEST_DRIVER                               | oracle                                 |
      | TEST_USERNAME                             | tombrady                               |
      | TEST_PASSWORD                             | password                               |
      | TEST_URL                                  | jdbc:oracle:thin:@10.1.1.1:1521:testdb |
      | TEST_NONXA                                | true                                   |
      | TEST_JTA                                  | true                                   |
      | TIMER_SERVICE_DATA_STORE                  | TEST                                   |
      | TIMER_SERVICE_DATA_STORE_REFRESH_INTERVAL | 60000                                  |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:/jboss/datasources/testds on XPath //*[local-name()='datasource']/@jndi-name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value jdbc:oracle:thin:@10.1.1.1:1521:testdb on XPath //*[local-name()='connection-url']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value oracle on XPath //*[local-name()='datasource']/*[local-name()='driver']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value tombrady on XPath //*[local-name()='datasource']/*[local-name()='security']/*[local-name()='user-name']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value password on XPath //*[local-name()='datasource']/*[local-name()='security']/*[local-name()='password']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test-TEST_part on XPath //*[local-name()='database-data-store']/@partition
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value 60000 on XPath //*[local-name()='database-data-store']/@refresh-interval

  Scenario: CLOUD-2068, test timer datasource refresh-interval
    When container is started with env
      | variable                 | value                                  |
      | DATASOURCES              | TEST                                   |
      | TEST_JNDI                | java:/jboss/datasources/testds         |
      | TEST_DRIVER              | oracle                                 |
      | TEST_USERNAME            | tombrady                               |
      | TEST_PASSWORD            | password                               |
      | TEST_URL                 | jdbc:oracle:thin:@10.1.1.1:1521:testdb |
      | TEST_NONXA               | true                                   |
      | TEST_JTA                 | true                                   |
      | TIMER_SERVICE_DATA_STORE | TEST                                   |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:/jboss/datasources/testds on XPath //*[local-name()='datasource']/@jndi-name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value jdbc:oracle:thin:@10.1.1.1:1521:testdb on XPath //*[local-name()='connection-url']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value oracle on XPath //*[local-name()='datasource']/*[local-name()='driver']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value tombrady on XPath //*[local-name()='datasource']/*[local-name()='security']/*[local-name()='user-name']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value password on XPath //*[local-name()='datasource']/*[local-name()='security']/*[local-name()='password']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test-TEST_part on XPath //*[local-name()='database-data-store']/@partition
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value -1 on XPath //*[local-name()='database-data-store']/@refresh-interval

  Scenario: Test background-validation configuration with custom background-validation-milis value
    When container is started with env
      | variable                                  | value                |
      | DB_SERVICE_PREFIX_MAPPING                 | test-postgresql=TEST |
      | TEST_DATABASE                             | 007                  |
      | TEST_USERNAME                             | hello                |
      | TEST_PASSWORD                             | world                |
      | TEST_POSTGRESQL_SERVICE_HOST              | 10.1.1.1             |
      | TEST_POSTGRESQL_SERVICE_PORT              | 5432                 |
      | TEST_NONXA                                | true                 |
      | TEST_BACKGROUND_VALIDATION                | true                 |
      | TEST_BACKGROUND_VALIDATION_MILLIS         | 3000                 |
      | TIMER_SERVICE_DATA_STORE_REFRESH_INTERVAL | 60000                |
      | TIMER_SERVICE_DATA_STORE                  | test-postgresql      |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='datasource']/@jndi-name
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value hello on XPath //*[local-name()='datasource']/*[local-name()='security']/*[local-name()='user-name']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value world on XPath //*[local-name()='datasource']/*[local-name()='security']/*[local-name()='password']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value false on XPath //*[local-name()='validation']/*[local-name()='validate-on-match']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value true on XPath //*[local-name()='validation']/*[local-name()='background-validation']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value 3000 on XPath //*[local-name()='validation']/*[local-name()='background-validation-millis']
    And XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value 60000 on XPath //*[local-name()='database-data-store']/@refresh-interval

 Scenario: check mysql datasource with specified DEFAULT_JOB_REPOSITORY and TIMER_SERVICE
    # Tests settings which override the defaults we checked in the 'check mysql datasource' scenario
    When container is started with env
       | variable                  | value                        |
       | DB_SERVICE_PREFIX_MAPPING | test-mysql=TEST              |
       | TEST_DATABASE             | kitchensink                  |
       | TEST_USERNAME             | marek                        |
       | TEST_PASSWORD             | hardtoguess                  |
       | TEST_MYSQL_SERVICE_HOST   | 10.1.1.1                     |
       | TEST_MYSQL_SERVICE_PORT   | 3306                         |
       | JDBC_SKIP_RECOVERY        | true                         |
       | DEFAULT_JOB_REPOSITORY    | test-mysql                   |
       | TIMER_SERVICE_DATA_STORE  | test-mysql                   |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
    # Skip a lot of the checks done in 'check mysql datasource' anyway
    # Now for what we are after....
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST on XPath //*[local-name()='default-job-repository']/@name
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_ds on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_ds on XPath //*[local-name()='database-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='database-data-store']/@datasource-jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value mysql on XPath //*[local-name()='database-data-store']/@database
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_part on XPath //*[local-name()='database-data-store']/@partition

  Scenario: check postgresql datasource with specified DEFAULT_JOB_REPOSITORY and TIMER_SERVICE
    # Tests settings which override the defaults we checked in the 'check posgresql datasource' scenario
    When container is started with env
       | variable                  | value                            |
       | DB_SERVICE_PREFIX_MAPPING     | test-postgresql=TEST         |
       | TEST_DATABASE                 | kitchensink                  |
       | TEST_USERNAME                 | marek                        |
       | TEST_PASSWORD                 | hardtoguess                  |
       | TEST_POSTGRESQL_SERVICE_HOST  | 10.1.1.1                     |
       | TEST_POSTGRESQL_SERVICE_PORT  | 5432                         |
       | JDBC_SKIP_RECOVERY            | true                         |
       | DEFAULT_JOB_REPOSITORY        | test-postgresql              |
       | TIMER_SERVICE_DATA_STORE      | test-postgresql              |
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST on XPath //*[local-name()='xa-datasource']/@pool-name
    # Skip a lot of the checks done in 'check postgresql datasource' anyway
    # Now for what we are after....
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST on XPath //*[local-name()='default-job-repository']/@name
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_ds on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_ds on XPath //*[local-name()='database-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='database-data-store']/@datasource-jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value postgresql on XPath //*[local-name()='database-data-store']/@database
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_part on XPath //*[local-name()='database-data-store']/@partition

  Scenario: check mysql and postgresql datasource with specified DEFAULT_JOB_REPOSITORY, TIMER_SERVICE and EE_DEFAULT_DS_JNDI_NAME set to first ds
    When container is started with env
       | variable                  | value                                                      |
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
       | DEFAULT_JOB_REPOSITORY        | test-postgresql                                        |
       | TIMER_SERVICE_DATA_STORE      | test-postgresql                                        |
       | EE_DEFAULT_DATASOURCE         | test-postgresql                                        |
    # We test a this in more detail in 'check mysql and postgresql datasource'. Just a quick sanity check here
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL on XPath //*[local-name()='xa-datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL on XPath //*[local-name()='xa-datasource']/@pool-name
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL on XPath //*[local-name()='default-job-repository']/@name
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL_ds on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL_ds on XPath //*[local-name()='database-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='database-data-store']/@datasource-jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value postgresql on XPath //*[local-name()='database-data-store']/@database
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL_part on XPath //*[local-name()='database-data-store']/@partition
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_postgresql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should not contain WARN The default datasource for the ee subsystem has been guessed to be

  Scenario: check mysql and postgresql datasource with specified DEFAULT_JOB_REPOSITORY, TIMER_SERVICE and EE_DEFAULT_DS_JNDI_NAME set to second ds
    When container is started with env
       | variable                  | value                                                      |
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
       | DEFAULT_JOB_REPOSITORY        | test-mysql                                             |
       | TIMER_SERVICE_DATA_STORE      | test-mysql                                             |
       | EE_DEFAULT_DATASOURCE         | test-mysql                                             |
    # We test a this in more detail in 'check mysql and postgresql datasource'. Just a quick sanity check here
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_postgresql-TEST_POSTGRESQL on XPath //*[local-name()='xa-datasource']/@pool-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL on XPath //*[local-name()='xa-datasource']/@pool-name
    # Default job repository
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL on XPath //*[local-name()='default-job-repository']/@name
    # Timer service
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL_ds on XPath //*[local-name()='timer-service']/@default-data-store
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL_ds on XPath //*[local-name()='database-data-store']/@name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='database-data-store']/@datasource-jndi-name
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value mysql on XPath //*[local-name()='database-data-store']/@database
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value test_mysql-TEST_MYSQL_part on XPath //*[local-name()='database-data-store']/@partition
    # EE default bindings
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should contain value java:jboss/datasources/test_mysql on XPath //*[local-name()='default-bindings']/@datasource
    And container log should not contain WARN The default datasource for the ee subsystem has been guessed to be
