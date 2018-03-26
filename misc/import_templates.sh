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

# update the other streams we might need for templates etc
for resource in amq/amq62-image-stream.json \
  amq/amq63-image-stream.json \
  processserver/processserver64-image-stream.json \
  processserver/processserver63-image-stream.json \
  openjdk/openjdk18-image-stream.json \
  eap/eap71-image-stream.json \
  eap/eap64-image-stream.json \
  eap/eap70-image-stream.json \
  datavirt/datavirt63-image-stream.json \
  sso/sso72-image-stream.json \
  sso/sso70-image-stream.json \
  sso/sso71-image-stream.json \
  decisionserver/decisionserver63-image-stream.json \
  decisionserver/decisionserver64-image-stream.json \
  decisionserver/decisionserver62-image-stream.json \
  webserver/jws30-tomcat7-image-stream.json \
  webserver/jws30-tomcat8-image-stream.json \
  webserver/jws31-tomcat8-image-stream.json \
  webserver/jws31-tomcat7-image-stream.json \
  datagrid/datagrid65-image-stream.json \
  datagrid/datagrid71-image-stream.json
do
  oc replace -n openshift --force -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/$resource
done
