#!/bin/bash

MQTT_SERVER=`cat /etc/inverter/mqtt.json | jq '.server' -r`
MQTT_PORT=`cat /etc/inverter/mqtt.json | jq '.port' -r`
MQTT_TOPIC=`cat /etc/inverter/mqtt.json | jq '.topic' -r`
MQTT_DEVICENAME=`cat /etc/inverter/mqtt.json | jq '.devicename' -r`
MQTT_SERIAL=`cat /etc/inverter/mqtt.json | jq '.serial' -r`
MQTT_USERNAME=`cat /etc/inverter/mqtt.json | jq '.username' -r`
MQTT_PASSWORD=`cat /etc/inverter/mqtt.json | jq '.password' -r`

while read rawcmd;
do

    echo "Incoming request send: [$rawcmd] to inverter."
    /opt/inverter-cli/bin/inverter_poller -r $rawcmd;

done < <(mosquitto_sub -h $MQTT_SERVER -p $MQTT_PORT -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -i ""$MQTT_DEVICENAME"_"$MQTT_SERIAL"" -t "$MQTT_TOPIC/sensor/$MQTT_DEVICENAME_$MQTT_SERIAL" -q 1)
