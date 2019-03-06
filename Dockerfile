FROM centos:7

RUN yum update -y \
	&& yum install -y https://www.percona.com/redir/downloads/percona-release/redhat/latest/percona-release-0.1-6.noarch.rpm \
	&& rpmkeys --import https://www.percona.com/downloads/percona-release/RPM-GPG-KEY-percona \
	&& rpm --import /etc/pki/rpm-gpg/PERCONA-PACKAGING-KEY \
	&& yum install -y Percona-Server-client-56 proxysql which \
	&& yum clean all \
	&& rm -rf /var/cache/yum \
	&& curl https://raw.githubusercontent.com/percona/proxysql-admin-tool/v1.4.14/proxysql-admin --output /usr/local/bin/proxysql-admin \
	&& chmod +x /usr/local/bin/proxysql-admin

ADD ./proxysql.cnf /etc/proxysql/proxysql.cnf
ADD ./proxysql-entry.sh /opt/proxysql-entry.sh
ADD ./add_cluster_nodes.sh /usr/local/bin/add_cluster_nodes.sh
ADD ./peer-list /usr/local/bin/peer-list

VOLUME /var/lib/proxysql

EXPOSE 3306 6032
ENTRYPOINT ["/opt/proxysql-entry.sh"]
