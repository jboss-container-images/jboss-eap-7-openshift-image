@jboss-eap-7/eap70-openshift
Feature: Common tests

  # https://issues.jboss.org/browse/CLOUD-2208
  Scenario: No repository files are left
    When container is ready
    # We do expect a single redhat.repo file
    Then run sh -c 'ls -1 /etc/yum.repos.d/ | wc -l' in container and immediately check its output contains 1

