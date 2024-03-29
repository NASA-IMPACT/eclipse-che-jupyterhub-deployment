#!/bin/sh
echo QU:$QUALIFIER
CLUSTER_NAME=$(aws eks list-clusters --query "clusters[?contains(@, 'analytics-cluster-$QUALIFIER')]" --output text)
echo "Cluster name is $CLUSTER_NAME"
IDP_COUNT="$(($(eksctl get identityprovider --cluster $CLUSTER_NAME | wc -l)-1))"
echo "Found $IDP_COUNT IDP(s)"
export CLUSTER_NAME=${CLUSTER_NAME}
if [ $IDP_COUNT -eq 0 ]; then
  envsubst < scripts/templates/associate-identity-provider-template.yaml > associate-identity-provider.yaml
  echo "-----------------------"
  echo "Generated IDP file"
  echo "-----------------------"
  cat associate-identity-provider.yaml
  echo "\n-----------------------"
  eksctl associate identityprovider -f associate-identity-provider.yaml
fi
