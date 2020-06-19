#!/bin/bash

curl -LJO https://s3.amazonaws.com/gitlab-runner-downloads/master/deb/gitlab-runner_amd64.deb

dpkg -i gitlab-runner_amd64.deb

gitlab-runner register \
    --non-interactive \
    --url "http://demo.seda.com/" \
    --registration-token "$1" \
    --description "demo-runner" \
    --executor "shell" \
    --tag-list "demo"

usermod -aG docker gitlab-runner
sudo -u gitlab-runner -H docker info

