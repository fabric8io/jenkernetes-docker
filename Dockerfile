FROM waprin/jenkernetes
MAINTAINER fabric8.io (http://fabric8.io/)

RUN echo metrics >> /usr/share/jenkins/plugins.txt && \
	echo notification >> /usr/share/jenkins/plugins.txt && \
	plugins.sh /usr/share/jenkins/plugins.txt

RUN cd /usr/local && \
  wget https://github.com/github/hub/releases/download/v2.2.1/hub-linux-amd64-2.2.1.tar.gz && \
  tar xf /usr/local/hub-linux-amd64-2.2.1.tar.gz && \
  rm /usr/local/hub-linux-amd64-2.2.1.tar.gz && \
  ln -s /usr/local/hub-linux-amd64-2.2.1/hub /usr/bin/hub

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

#ENV DOCKER_HOST tcp://localhost:2375
ENV DOCKER_HOST unix:///var/run/docker.sock
ENV SEED_GIT_URL https://github.com/fabric8io/default-jenkins-dsl.git

ENV KUBERNETES_TRUST_CERT true
ENV SKIP_TLS_VERIFY true

ADD fabric8-jenkins-workflow-steps-1.0.hpi /usr/share/jenkins/ref/plugins/


ADD jenkins.properties /usr/share/jenkins/ref/
ADD load-properties.groovy /usr/share/jenkins/ref/init.groovy.d/
