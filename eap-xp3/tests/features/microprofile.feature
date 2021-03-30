@jboss-eap-7
Feature: EAP XP microprofile tests

# Although we don't support officialy exclusion, let's test that we can provision it.
Scenario: Test microprofile config.
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,microprofile-openapi,microprofile-jwt,microprofile-fault-tolerance,-jpa,jpa-distributed,web-clustering  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |