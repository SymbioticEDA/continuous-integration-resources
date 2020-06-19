# Docker

Build the docker image with the [build-ci-docker.sh] shell script.
You will need the Symbiotic EDA tools download and license file in the same directory.

    ./build-ci-docker.sh <filename of tools> <license file> <tag for docker>

Then you can run

    docker images

And you should see the new image available. This can be copied to your CI machines.

# Gitlab

Go to the projects CI configuration and find the section to add a new runner. You need to copy the token.
Then use the [runner-setup.sh] script to download, install and configure the gitlab runner:

    sudo ./runner-setup.sh <token>

Add a [.gitlab-ci.yml] file to your repository and configure it as you like. With the example, the 
proofs will be run on push and merge.

# Jenkins

Choose a freestyle project. Then configure as follows.

## Build script

    cd /vagrant/demo-project
    docker run --user `id -u`:`id -g` --rm -v $(pwd):/work seda_ci:symbiotic-20200608A /bin/bash ci.sh

## Build trigger

    define a token and copy it. Copy the URL and use it to adapt the post-commit shell script.

## git post-commit hook

Add your token and URL to this script, and copy to your .git/hooks directory as post-commit

    #!/bin/bash
    curl -I http://demo.seda.com:9080/job/demo-ci/build?token=<token>

Now when you git commit, the build will be triggered.
