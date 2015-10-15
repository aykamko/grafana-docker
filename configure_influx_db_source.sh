#!/bin/bash
#modified from: https://github.com/tutumcloud/grafana/blob/master/set_influx_db.sh
set -e

if [ -f /.influx_db_configure ]; then
    echo "=> InfluxDB has been configured!"
    exit 0
fi

if [ "${INFLUXDB_HOST}" = "**ChangeMe**" ]; then
    echo "=> No address for InfluxDB is specified."
    echo "=> Skipping setting InfluxDB"
    exit 0
fi

if [ "${INFLUXDB_PORT}" = "**ChangeMe**" ]; then
    echo "=> No port for InfluxDB is specified."
    echo "=> Skipping setting InfluxDB"
    exit 0
fi

echo "=> Configuring InfluxDB"

sed -i -e "s/<--PROTO-->/${INFLUXDB_PROTO}/g" \
    -e "s/<--HOST-->/${INFLUXDB_HOST}/g" \
    -e "s/<--PORT-->/${INFLUXDB_PORT}/g" \
    -e "s/<--DASH_NAME-->/${INFLUXDB_GRAFANA_DASH_NAME}/g" \
    -e "s/<--DB_NAME-->/${INFLUXDB_NAME}/g" \
    -e "s/<--USER-->/${INFLUXDB_USER}/g" \
    -e "s/<--PASS-->/${INFLUXDB_PASS}/g" \
    /tmp/add_influx_db_source.sql

sqlite3 /var/lib/grafana/grafana.db < /tmp/add_influx_db_source.sql
touch /.influx_db_configure

echo "=> InfluxDB has been configured as follows:"
echo "   InfluxDB ADDRESS:  ${INFLUXDB_HOST}"
echo "   InfluxDB PORT:     ${INFLUXDB_PORT}"
echo "   InfluxDB DB NAME:  ${INFLUXDB_NAME}"
echo "   InfluxDB USERNAME: ${INFLUXDB_USER}"
echo "   InfluxDB PASSWORD: ${INFLUXDB_PASS}"
echo "   ** Please check your environment variables if you find something is misconfigured. **"
echo "=> Done!"
