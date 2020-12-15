@jboss-eap-7
Feature: EAP XP common tests

  # https://issues.jboss.org/browse/CLOUD-180
  Scenario: Check if image version and release is printed on boot
    When container is ready
    Then container log should contain Running jboss-eap-7/eap-xp2-openjdk11-openshift-rhel8 image, version

  Scenario: Check that the labels are correctly set
    Given image is built
    Then the image should contain label com.redhat.component with value jboss-eap-7-eap-xp2-openjdk11-openshift-rhel8-container
    And the image should contain label name with value jboss-eap-7/eap-xp2-openjdk11-openshift-rhel8
    And the image should contain label io.openshift.expose-services with value 8080:http
    And the image should contain label io.openshift.tags with value builder,javaee,eap,eap7,eap-xp
