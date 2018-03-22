#!/bin/bash -x
LPREFIX=jboss-eap-7-tech-preview
LNAME=eap-cd-openshift
PREFIX=openshift
NAME=eap-cd-openshift
VERSION="12.0"
VERSION_TAG="12"
PORT=5000

oc cluster up # start cluster
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin developer
oc login -u developer
oc create route edge --service=docker-registry -n default
oc create -n $PREFIX -f templates/eap-cd-image-stream.json
oc create -n myproject -f secrets
sleep 5
AUTH=`oc whoami -t`
CLUSTER_IP=`oc get -n default svc/docker-registry -o=yaml | grep clusterIP  | awk -F: '{print $2}'`
docker tag $LPREFIX/$LNAME:latest $LPREFIX/$LNAME:12.0

docker login -u developer -p $AUTH $CLUSTER_IP:$PORT
#jboss-eap-7-tech-preview/eap-cd-openshift:12.0
docker tag $LPREFIX/$LNAME:$VERSION $CLUSTER_IP:$PORT/$PREFIX/$NAME:$VERSION
docker tag $LPREFIX/$LNAME:$VERSION $CLUSTER_IP:$PORT/$PREFIX/$NAME:$VERSION_TAG
docker push $CLUSTER_IP:$PORT/$PREFIX/$NAME:$VERSION
docker push $CLUSTER_IP:$PORT/$PREFIX/$NAME:$VERSION_TAG

# testsuite uses the docker img - doesnt, not needed?
#docker tag jboss-eap-7/eap-cd:latest $CLUSTER_IP:$PORT/$PREFIX/$NAME:$VERSION
#docker tag jboss-eap-7/eap-cd:latest $CLUSTER_IP:$PORT/$PREFIX/$NAME:$VERSION_TAG
#docker push $CLUSTER_IP:5000/openshift/eap-cd:12
#docker push $CLUSTER_IP:5000/openshift/eap-cd:12.0

