#!/bin/bash

set -o errexit
set -o nounset
# set -o pipefail
set -ex

CURRENT_DIR="${PWD##*/}"
GCP_KEY="/usr/local/etc/key2.json"
CLUSTER_NAME="chaos-cluster"
NAMESPACE="qa-no-affinity"
STACK_COUNT=4

get_local_templates_count() {
  set -o errexit
  set -o nounset
  set -ex
  local -n VAR=$1
  VAR=$(mncc list --local | grep $NAMESPACE | awk '{print $1}' | wc -l)
}

get_local_templates_count local_templates
echo $local_templates

if ! [[ $local_templates == 0 ]]
then
  echo 'local templates exist'
  exit 
fi

mncc load cluster-no-affinity.yaml

get_local_templates_count local_templates
echo $local_templates

if ! [[ $local_templates == $STACK_COUNT ]]
then 
  echo 'local templates dont match'
  exit 
fi

mncc run -t $CLUSTER_NAME qa-no-affinity/system
