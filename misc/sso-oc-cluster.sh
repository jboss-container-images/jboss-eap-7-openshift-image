#!/bin/bash

oc cluster up # start cluster
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin developer
oc login -u developer
oc create route edge --service=docker-registry -n default
sleep 5
AUTH=`oc whoami -t`
CLUSTER_IP=`oc get -n default svc/docker-registry -o=yaml | grep clusterIP  | awk -F: '{print $2}'`
docker login -u developer -p $AUTH $CLUSTER_IP:5000
docker tag jboss-eap-7-tech-preview/eap-online-openshift:12.0 $CLUSTER_IP:5000/openshift/eap-online-openshift:12
docker tag jboss-eap-7-tech-preview/eap-online-openshift:12.0 $CLUSTER_IP:5000/openshift/eap-online-openshift:12.0
docker push $CLUSTER_IP:5000/openshift/eap-online-openshift:12
docker push $CLUSTER_IP:5000/openshift/eap-online-openshift:12.0
oc create -n myproject -f secrets
oc process -n myproject -f templates/eap-online/eap-online-sso-s2i.json -p APPLICATION_NAME=helloworld-sso -p HOSTNAME_HTTP=localhost -p HOSTNAME_HTTPS=localhost -pSSO_URL=http://localhost/ -pSSO_REALM=helloworld-sso | oc create -n myproject -f -


