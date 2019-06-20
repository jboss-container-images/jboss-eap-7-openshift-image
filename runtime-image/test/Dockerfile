#Be sure to update eap-testapp with the name of the image generated with s2i.
FROM jboss-eap-7/eap-cd-runtime-openshift:latest
COPY --from=eap-testapp:latest /s2i-output/server $JBOSS_HOME
USER root
RUN chown -R jboss:root $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME
USER jboss
CMD $JBOSS_HOME/bin/openshift-launch.sh
