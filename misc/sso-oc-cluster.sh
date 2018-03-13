#!/bin/bash
./misc/setup-templates.sh
oc process -n myproject -f templates/eap-online/eap-online-sso-s2i.json -p APPLICATION_NAME=helloworld-sso -p HOSTNAME_HTTP=localhost -p HOSTNAME_HTTPS=localhost -pSSO_URL=http://localhost/ -pSSO_REALM=helloworld-sso | oc create -n myproject -f -


