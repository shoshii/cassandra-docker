ARG VERSION=
FROM shoshii/cassandra-centos:${VERSION}
ADD conf/cassandra.yaml /etc/cassandra/conf/
ADD conf/cassandra-rackdc.properties /etc/cassandra/conf/

USER cassandra
CMD ["cassandra", "-f"]