FROM finmason/docker-alpine-java:latest
MAINTAINER Sean Abbott "sabbott@finmason.com"

#
## Env
ENV SOLR_VERSION 6.2.1
ENV SOLR solr-$SOLR_VERSION
ENV JDBC_MYSQL_VERSION 5.1.38
ENV JDBC_PSQL_VERSION 9.4.1207
##
#

#
## Install
RUN [ -e /sbin/apk ] && ( [ -e /bin/bash ] || apk add --update bash ) || \
    ( [ -e /usr/bin/apt-get ] && ( apt-get update && apt-get dist-upgrade -y && apt-get install -y ca-certificates patch unzip && apt-get clean all && which unzip && which patch ) || ( echo "no \"apk\", no \"apt-get\", what are you running, Gentoo?" >&2 && exit 1 ) ) && \
    ( which curl || apk add --update curl ) && \
    cd /tmp && \
    echo "getting solr $SOLR_VERSION" >&2 && \
    wget http://archive.apache.org/dist//lucene/solr/$SOLR_VERSION/$SOLR.tgz -O /tmp/$SOLR.tgz && \
    mkdir -p /opt && \
    tar -C /opt -xzf /tmp/$SOLR.tgz && \
    ln -sf /opt/$SOLR /opt/solr && \
    echo "getting PSQL JDBC" >&2 && \
    curl -sSL http://jdbc.postgresql.org/download/postgresql-$JDBC_PSQL_VERSION.jar -o /opt/solr/dist/postgresql-$JDBC_PSQL_VERSION.jar && \
    echo "getting MYSQL JDBC" >&2 && \
    curl -sSL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz -o /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz && \
    echo mysql-connector-java-$JDBC_MYSQL_VERSION/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar > /tmp/include && \
    gzip -dc /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz | tar -x -T /tmp/include > /opt/solr/dist/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar && \
    echo "cleaning up.." >&2 && \
    apk del curl || true && \
    rm -rf /tmp/*
##
#
ADD ./scripts/one_index_to_rule_them.sh /usr/local/bin/one_index_to_rule_them.sh

EXPOSE 8983
ADD ./docker-entrypoint.sh /entrypoint.sh
WORKDIR /opt/solr
ENTRYPOINT ["/entrypoint.sh"]
