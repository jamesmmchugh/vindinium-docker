#!/bin/bash

getIpAddressesForMongoDb() {
echo `aws ec2 describe-instances | jq '.Reservations[].Instances[] | select(.State.Code != 48) | select(.Tags[] | select(.Key=="Name") | select(.Value == "mongodb")) | [(.PrivateIpAddress),(.PublicIpAddress)] '`
}

getIpAddressesForApp() {
echo `aws ec2 describe-instances | jq '.Reservations[].Instances[] | select(.State.Code != 48) | select(.Tags[] | select(.Key=="Name") | select(.Value == "vindinium")) | [(.PrivateIpAddress),(.PublicIpAddress)]'`
}

MONGODB_IPS=`getIpAddressesForMongoDb mongodb`
APP_IPS=`getIpAddressesForApp vindinium`

MONGODB=(`echo ${MONGODB_IPS} | tr -d '[]",'`)
APP=(`echo ${APP_IPS} | tr -d '[]",'`)

echo "
[mongodb]
${MONGODB[1]} private_ip=${MONGODB[0]} ansible_connection=ssh

[app]
${APP[1]} private_ip=${APP[0]} ansible_connection=ssh
" > inventory.yml
