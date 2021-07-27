FROM centos:7
RUN yum install -y java
RUN yum install -y python3
ARG PKG_NAME=""
ADD rpms/${PKG_NAME} /tmp/
RUN rpm -ivh /tmp/${PKG_NAME}

ARG TOOL_PKG_NAME=""
ADD rpms/${TOOL_PKG_NAME} /tmp/
RUN rpm -ivh /tmp/${TOOL_PKG_NAME}

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

ENV LOCAL_JMX=no

USER cassandra
CMD ["cassandra", "-f"]