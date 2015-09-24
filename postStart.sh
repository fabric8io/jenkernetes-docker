#!/usr/bin/env bash

# ***** IMPORTANT *****
# add lots of error handling.  If this script fails it's hard to know why the pods keeps restarting

if [ -d "/var/jenkins/.ssh-git" ]; then
  chmod 600 /var/jenkins/.ssh-git/ssh-key
  chmod 600 /var/jenkins/.ssh-git/ssh-key.pub
  chmod 700 /var/jenkins/.ssh-git
fi
if [ -d "/root/.gnupg" ]; then
  chmod 600 /root/.gnupg/pubring.gpg
  chmod 600 /root/.gnupg/secring.gpg
  chmod 600 /root/.gnupg/trustdb.gpg
  chmod 700 /root/.gnupg
fi

if [ "$JENKINS_WORKFLOW_GIT_REPOSITORY" ]; then
  git clone "$JENKINS_WORKFLOW_GIT_REPOSITORY" /root/repositoryscripts

  # only continue if repo contains the correct directory structure
  # as per https://github.com/jenkinsci/workflow-plugin/tree/master/cps-global-lib#directory-structure
  if [[ -d "/root/repositoryscripts/src" && -d "/root/repositoryscripts/vars" ]]; then
    # printf 'waiting for the workflow git repo to be ready'
    # wait for jenkins to start
    until $(curl --output /dev/null --silent --head --fail http://localhost:8080/workflowLibs.git); do
        printf '.'
        sleep 5
    done

    git clone http://localhost:8080/workflowLibs.git /root/workflowLibs
    cd /root/workflowLibs
    git checkout -b master
    mv /root/repositoryscripts/src .
    mv /root/repositoryscripts/vars .
    git add vars src
    git config --global user.email "jenkins@fabric8.io"
    git config --global user.name "Jenkins admin"
    git commit -m "Initialise the Workflow global repo with default scripts"
    git push origin master

    rm -rf /root/workflowLibs
    rm -rf /root/repositoryscripts

  fi
fi
