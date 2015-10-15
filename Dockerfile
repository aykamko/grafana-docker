FROM debian:jessie

ENV GRAFANA_VERSION 2.1.3

RUN apt-get update && \
    apt-get -y install libfontconfig wget adduser openssl ca-certificates sqlite3 && \
    apt-get clean && \
    wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb -O /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

ENV INFLUXDB_PROTO http
ENV INFLUXDB_HOST **ChangeMe**
ENV INFLUXDB_PORT 8086
ENV INFLUXDB_DASH_NAME default
ENV INFLUXDB_NAME **ChangeMe**
ENV INFLUXDB_USER root
ENV INFLUXDB_PASS root

ADD add_influx_db_source.sql /tmp/add_influx_db_source.sql
ADD configure_influx_db_source.sql /tmp/configure_influx_db_source.sql
RUN /tmp/configure_influx_db_source

ENTRYPOINT ["/usr/sbin/grafana-server", "--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.logs=/var/log/grafana"]

RUN [ -f /.influx_db_configure ] && sqlite3 /var/lib/grafana/grafana.db < /tmp/add_influx_db_source.sql
