FROM centos:7
RUN yum install -y java
RUN yum install -y python3
ARG PKG_NAME=cassandra-4.0.1-20210715git51f16a3.el7.noarch.rpm
ADD files/${PKG_NAME} /tmp/
RUN rpm -ivh /tmp/${PKG_NAME}

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160
USER cassandra
CMD ["cassandra", "-f"]