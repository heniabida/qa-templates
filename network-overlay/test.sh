#!/bin/bash

set -ex

CURRENT_DIR="${PWD##*/}"
GCP_KEY="/Users/toymachine/Projects/moncc/key2.json"

cd telegraf
./push.sh latest

cd ../

mncc login --email=$MONCC_MAIL --password=$MONCC_APASS

mncc c new -n cluster-1 && mncc c provider add -p gcp -f $GCP_KEY

mncc cluster grow --provider=gcp \
    --name=chaos \
    --tag=chaos-cluster \
    --instance-type=n2-standard-2 \
    --region=europe-west4 \
    --zone=europe-west4-c \
    --disk-size=10 -m 5

mncc load chaos-cluster.yaml && mncc run chaos-cluster/system
# mncc load discourse.yaml && mncc run discourse/stack-ssl
