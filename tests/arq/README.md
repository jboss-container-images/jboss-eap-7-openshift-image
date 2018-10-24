# Arquillian Tests for JBoss EAP

This project contains OpenShift v3 tests for the JBoss EAP OpenShift image

## Requirements

The following are required to run the tests:

* Maven 3+
* Available `oc` command
* OpenShift environment, for example `oc cluster up` for running tests locally
* You should use DNS server that is able to resolve domains used/create by OpenShift environment

## Usage

To test an image locally, you will need to do the following
* Build the image and push it to a docker registry accessible to your OpenShift instance, e.g.
```
$ docker login some-docker-registry -t <TOKEN>
$ docker tag tag jboss-eap-7/eap-cd-openshift:14.0 some-docker-registry/somenamespace/eap-cd-openshift:14.0
$ docker push some-docker-registry/somenamespace/eap-cd-openshift:14.0
```
* You should be logged in to your openshift cluster
```
$ oc login -u developer
```
* run the tests locally as follows
```
$ mvn test -Dimage=some-docker-registry/somenamespace/eap-cd-openshift:14.0 -DforkCount=1
```
You can use a forkCount greater than 1 if you have sufficient resources. Using higher values with `oc cluster up` on a workstation may cause concurrent load issues and timeouts.

For debugging and additional testing, use `-Dnamespace.cleanup.enabled=false -Dnamespace.destroy.enabled=false` to disable the testing namespace automatic cleanup and removal. Example:

```
$ mvn test -Dimage=some-docker-registry/somenamespace/eap-cd-openshift:14.0 -DforkCount=1 -Dnamespace.cleanup.enabled=false -Dnamespace.destroy.enabled=false
```

# Templates
To use alternative templates, you can specify an alternative URL:
```
mvn test -Dimage=some-docker-registry/somenamespace/eap-cd-openshift:14.0 -Dtemplate.uri=https://raw.githubusercontent.com/luck3y/jboss-eap-7-openshift-image/CLOUD-2691/templates
```
