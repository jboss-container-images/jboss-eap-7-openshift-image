#!/bin/bash
############################################################################################################################################
# NOTE: this needs the amq imagestreams installed: oc create -n openshift -f ~/os/git/application-templates/amq/amq62-image-stream.json    #
############################################################################################################################################
./misc/setup-templates.sh
oc process -n myproject -f templates/eap-cd/eap-cd-amq-persistent-s2i.json -p APPLICATION_NAME=helloworld-amqpersist -p SOURCE_REPOSITORY_URL=https://github.com/jboss-developer/jboss-eap-quickstarts -p SOURCE_REPOSITORY_REF=7.0.0.GA -p CONTEXT_DIR=helloworld | oc create -n myproject -f -

