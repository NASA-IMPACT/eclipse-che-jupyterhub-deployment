#!/bin/sh
CLUSTER_NAME=$(aws eks list-clusters --query "clusters[?contains(@, 'clusteranalyticscluster$QUALIFIER')]" --output text)
echo "Cluster name is $CLUSTER_NAME"
IDP_COUNT="$(($(eksctl get identityprovider --cluster $CLUSTER_NAME --name cognito-provider | wc -l)-1))"
echo "Found $IDP_COUNT IDP(s)"
export CLUSTER_NAME=${CLUSTER_NAME}
export CLUSTER_REGION="us-west-2"
if [ $IDP_COUNT -eq 0 ]; then
  envsubst < eks/associate-identity-provider-template.yaml > eks/associate-identity-provider.yaml
  echo "-----------------------"
  echo "Generated IDP file"
  echo "-----------------------"
  cat eks/associate-identity-provider.yaml
  echo "\n-----------------------"
  eksctl associate identityprovider -f eks/associate-identity-provider.yaml
fi
