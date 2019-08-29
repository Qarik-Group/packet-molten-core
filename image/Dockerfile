FROM ubuntu:bionic

RUN apt-get update && apt-get install -y build-essential zlibc zlib1g-dev \
    ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline7 \
    libreadline-dev libyaml-dev libsqlite3-dev sqlite3 jq git-core curl \
    net-tools iputils-ping

ENV BUCC_VERSION 8b33356
RUN git clone https://github.com/starkandwayne/bucc /bucc && \
    cd /bucc && git checkout ${BUCC_VERSION}


# RUN git clone https://github.com/rkoster/bosh-docker-cpi-release /tmp/bosh-docker-cpi-release && \
#     cd /tmp/bosh-docker-cpi-release && /bucc/bin/bucc env && \
#     /bucc/bin/bosh create-release --tarball /bosh-docker-cpi.tgz && \
#     rm -r /tmp/bosh-docker-cpi-release

# ADD use-docker-cpi-fork.yml /bucc/operators/

ADD entry.sh /bucc/

RUN cd bucc && ln -s state/vars.yml && \
    echo "source <(/bucc/bin/bucc env)" >> ~/.bashrc

VOLUME /bucc/state

ENTRYPOINT /bucc/entry.sh
