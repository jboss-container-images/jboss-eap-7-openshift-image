@jboss-eap-7
Feature: EAP XP Openshift open-tracing tests

  Scenario: No tracing
    When container is started with env
       | variable                    | value             |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 1 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/eap/standalone/configuration/standalone-openshift.xml should have 0 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]