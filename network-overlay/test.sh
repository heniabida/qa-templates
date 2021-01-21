#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -ex

CURRENT_DIR="${PWD##*/}"
GCP_KEY="/usr/local/etc/key2.json"
CLUSTER_NAME="chaos-cluster"
NO_PEERS=2

mncc login --email=$MONCC_ACC --password=$MONCC_PASS

mncc c new -n cluster-1 && mncc c provider add -p gcp -f $GCP_KEY

mncc cluster grow --provider=gcp \
    --name=chaos \
    --tag=$CLUSTER_NAME \
    --instance-type=n2-standard-2 \
    --region=europe-west4 \
    --zone=europe-west4-c \
    --disk-size=10 \
    -m $NO_PEERS

CLUSTER_SIZE=$(mncc c peers | grep $CLUSTER_NAME | awk '{print $1}' | wc -l)

echo $CLUSTER_SIZE
# if ! [[ $CLUSTER_SIZE == NO_PEERS ]]
# then 
#   echo 'peers'
#   exit 
# fi

