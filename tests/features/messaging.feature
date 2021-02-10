@jboss-eap-7-tech-preview
Feature: Openshift EAP Messaging Tests

  Scenario: deploys the helloworld-mdb example, then checks if it's deployed properly.
    Given s2i build https://github.com/jboss-developer/jboss-eap-quickstarts from helloworld-mdb with env using 7.4.0.Beta
      | variable              | value                                   |
      |  MAVEN_ARGS_APPEND    |  -Dcom.redhat.xpaas.repo.jbossorg       |
    Then container log should contain Bound messaging object to jndi name java:/queue/HELLOWORLDMDBQueue
    Then container log should contain Bound messaging object to jndi name java:/topic/HELLOWORLDMDBTopic
    Then container log should contain Started message driven bean 'HelloWorldQueueMDB' with 'activemq-ra.rar' resource adapter
    Then container log should contain Started message driven bean 'HelloWorldQTopicMDB' with 'activemq-ra.rar' resource adapter
