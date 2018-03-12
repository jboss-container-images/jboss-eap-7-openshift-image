#!/bin/bash
oc cluster up # start cluster
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin developer
oc login -u developer
oc create route edge --service=docker-registry -n default
oc create -n openshift -f templates/eap-online-image-streams.json
sleep 5
AUTH=`oc whoami -t`
CLUSTER_IP=`oc get -n default svc/docker-registry -o=yaml | grep clusterIP  | awk -F: '{print $2}'`
docker login -u developer -p $AUTH $CLUSTER_IP:5000
docker tag jboss-eap-7-tech-preview/eap-online-openshift:12.0 $CLUSTER_IP:5000/openshift/eap-online-openshift:12
docker tag jboss-eap-7-tech-preview/eap-online-openshift:12.0 $CLUSTER_IP:5000/openshift/eap-online-openshift:12.0
docker push $CLUSTER_IP:5000/openshift/eap-online-openshift:12
docker push $CLUSTER_IP:5000/openshift/eap-online-openshift:12.0
oc process -n myproject -f templates/eap-online/eap-online-postgresql-s2i.json -p APPLICATION_NAME=helloworld-postgres -p SOURCE_REPOSITORY_URL=https://github.com/jboss-developer/jboss-eap-quickstarts -p SOURCE_REPOSITORY_REF=7.0.0.GA -p CONTEXT_DIR=helloworld | oc create -n myproject -f -

