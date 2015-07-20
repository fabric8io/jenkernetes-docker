FROM waprin/jenkernetes
MAINTAINER fabric8.io (http://fabric8.io/)

# lets configure and add default jobs
COPY jenkins/*.xml /usr/share/jenkins/ref/
COPY jenkins/jobs /usr/share/jenkins/ref/jobs

# configure maven settings and nexus mirroring and authentication
#COPY mvnsettings.xml $JENKINS_HOME/.m2/settings.xml

# lets put a copy in the roots folder too for when running as root
COPY mvnsettings.xml /root/.m2/settings.xml


# these env vars should be replaced by kubernetes configuration in the OpenShift templates:
ENV NEXUS_USERNAME admin
ENV NEXUS_PASSWORD admin123

ENV JENKINS_GOGS_USER gogsadmin
ENV JENKINS_GOGS_PASSWORD RedHat$1
ENV JENKINS_GOGS_EMAIL gogsadmin@fabric8.local

ENV DOCKER_HOST tcp://localhost:2375
ENV SEED_GIT_URL https://github.com/fabric8io/default-jenkins-dsl.git

ENV KUBERNETES_MASTER https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}
ENV KUBERNETES_TRUST_CERT true
ENV SKIP_TLS_VERIFY true
ENV KUBERNETES_NAMESPACE default
