# Continuous Integration with Symbiotic EDA Formal tools.

This information is to support [this video](https://www.youtube.com/watch?v=eONyoVT3EOg&feature=youtu.be)

# Docker

Build the docker image with the [build-ci-docker.sh](build-ci-docker.sh) shell script.
You will need the Symbiotic EDA tools download and license file in the same directory.

    ./build-ci-docker.sh <filename of tools> <license file> <tag for docker>

Then you can run

    docker images

And you should see the new image available. This can be copied to your CI machines.

# Gitlab

Go to the projects CI configuration and find the section to add a new runner. You need to copy the token.
Then use the [runner-setup.sh](runner-setup.sh) script to download, install and configure the gitlab runner:

    sudo ./runner-setup.sh <token>

Add a [.gitlab-ci.yml](.gitlab-ci.yml) file to your repository and configure it as you like. With the example, the 
proofs will be run on push and merge. This example simply runs [ci.sh](ci.sh), but equally a Makefile could be used.

# Jenkins

We will use a github post-commit hook to tell Jenkins to run the build.
Then when you git commit, the build will be triggered.

Choose a freestyle project. Then configure as follows.

## Build triggers

Click the 'trigger builds remotely' checkbox.  Define a token and copy it. 
Copy the URL and use it to adapt the post-commit shell script.

Add your token and URL to the [post-commit](post-commit) script, and copy to your .git/hooks directory as post-commit

## Build

In the build section, choose shell script and then paste this:

    cd <your build directory>
    docker run --user `id -u`:`id -g` --rm -v $(pwd):/work seda_ci:symbiotic-20200608A /bin/bash <command to run the proofs>

The command we used in the video was [ci.sh](ci.sh)
