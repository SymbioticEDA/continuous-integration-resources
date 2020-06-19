#!/bin/bash
function usage {
	SCRIPT=`basename $0`
	echo Usage: $SCRIPT symbiotic-release.tar.gz license-file version
}
if [ $# != 3 ]; then
	usage $0
	exit 1
fi
docker build -t="seda_ci:$3" -f- "$(realpath $(dirname "${BASH_SOURCE[0]}"))" <<EOF
FROM ubuntu:18.04
ENV TZ=Europe/Vienna
RUN ln -snf /usr/share/zoneinfo/\$TZ /etc/localtime && echo \$TZ > /etc/timezone

RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
               make ca-certificates \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*
COPY $1 /.
RUN mkdir /symbiotic && cd /symbiotic && tar xvfz /$1 --strip-components=1 && rm -rf /$1
ENV PATH="/symbiotic/bin:\${PATH}"
RUN cd /symbiotic/bin && ./setup.sh
COPY $2 /symbiotic.lic
ENV SYMBIOTIC_LICENSE=/symbiotic.lic
WORKDIR /work
EOF
