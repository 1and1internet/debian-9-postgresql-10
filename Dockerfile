FROM golang as configurability_postgresql10
MAINTAINER brian.wilkinson@1and1.co.uk
WORKDIR /go/src/github.com/1and1internet/configurability
RUN git clone https://github.com/1and1internet/configurability.git . \
       && make postgresql10 \
       && echo "configurability postgresql10 plugin successfully built"

FROM 1and1internet/debian-9
MAINTAINER brian.wilkinson@1and1.co.uk
COPY --from=configurability_postgresql10 /go/src/github.com/1and1internet/configurability/bin/plugins/postgresql10.so /opt/configurability/goplugins
COPY files /
ARG PGVER=10
ARG LOG_DIR=/var/log/postgresql
ARG PGBIN=/usr/lib/postgresql/${PGVER}/bin

# PostgreSQL installation on debian using https://www.postgresql.org/download/linux/debian/

# Installation
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	&& apt-get update \
	&& apt-get install -y curl gnupg \
	&& curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
	&& apt-get update \
	&& apt-get install -y postgresql-${PGVER} postgresql-client-${PGVER} \
	&& apt-get remove curl gnupg \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

COPY files/ /

# Post installation configuration
RUN cp /opt/postgresql/bash_profile /var/lib/postgresql/.bash_profile \
	&& chown postgres:postgres /var/lib/postgresql/.bash_profile \
	&& mkdir -p /var/run/postgresql/${PGVER}-main.pg_stat_tmp \
	&& chown postgres:postgres /var/run/postgresql/${PGVER}-main.pg_stat_tmp \
	&& chmod +x /usr/local/bin/run_postgres \
	&& chmod -R 755 /init /hooks \
	&& cd /etc/postgresql/${PGVER}/main \
	&& mkdir -p ${LOG_DIR} \
	&& chmod -R 777 ${LOG_DIR} ${PGBIN} /var/lib/postgresql /var/run/postgresql

ENV PATH=$PATH:/usr/lib/postgresql/${PGVER}/bin \
	PGVER=${PGVER} \
	PG_BIN=${PGBIN} \
	PG_DBDIR=/var/lib/postgresql/${PGVER}/main \
	AUTH_METHOD=md5 \
	ADMIN_USER=admin123 \
	ADMIN_PASS=passw0rd \
	LOG_DIR=${LOG_DIR}

#VOLUME /var/lib/postgresql/${PGVER}
#VOLUME ${LOG_DIR}
#EXPOSE 5432
