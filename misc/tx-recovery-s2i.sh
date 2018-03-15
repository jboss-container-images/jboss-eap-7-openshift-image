#!/bin/bash
./misc/setup-templates.sh
oc process -n myproject -f templates/eap-cd/eap-cd-tx-recovery-s2i.json -p APPLICATION_NAME=helloworld-tx-recovery -p HOSTNAME_HTTP=localhost | oc create -n myproject -f -

