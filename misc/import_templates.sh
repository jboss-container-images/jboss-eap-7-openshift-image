#!/bin/bash

# import templates 

for resource in eap-cd-amq-persistent-s2i.json \
  eap-cd-amq-s2i.json \
  eap-cd-basic-s2i.json \
  eap-cd-https-s2i.json \
  eap-cd-mongodb-persistent-s2i.json \
  eap-cd-mongodb-s2i.json \
  eap-cd-mysql-persistent-s2i.json \
  eap-cd-mysql-s2i.json \
  eap-cd-postgresql-persistent-s2i.json \
  eap-cd-postgresql-s2i.json \
  eap-cd-sso-s2i.json \
  eap-cd-third-party-db-s2i.json \
  eap-cd-tx-recovery-s2i.json     
do
  oc replace -n openshift --force -f templates/${resource}
done

