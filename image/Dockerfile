FROM ubuntu:bionic

RUN apt-get update && apt-get install -y build-essential zlibc zlib1g-dev \
    ruby ruby-dev openssl libxslt1-dev libxml2-dev libssl-dev libreadline7 \
    libreadline-dev libyaml-dev libsqlite3-dev sqlite3 jq git-core curl \
    net-tools iputils-ping

ENV BUCC_VERSION 9977aad
RUN git clone https://github.com/starkandwayne/bucc /bucc && \
    cd /bucc && git checkout ${BUCC_VERSION}

RUN /bucc/bin/bucc env

ADD entry.sh /bucc/

RUN cd bucc && ln -s state/vars.yml && \
    echo "source <(/bucc/bin/bucc env)" >> ~/.bashrc

VOLUME /bucc/state

ENTRYPOINT /bucc/entry.sh
