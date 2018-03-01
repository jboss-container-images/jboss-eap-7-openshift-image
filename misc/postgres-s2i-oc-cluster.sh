#!/bin/bash
./misc/setup-templates.sh
oc process -n myproject -f templates/eap-cd/eap-cd-postgresql-s2i.json -p APPLICATION_NAME=helloworld-postgres -p SOURCE_REPOSITORY_URL=https://github.com/jboss-developer/jboss-eap-quickstarts -p SOURCE_REPOSITORY_REF=7.0.0.GA -p CONTEXT_DIR=helloworld | oc create -n myproject -f -

