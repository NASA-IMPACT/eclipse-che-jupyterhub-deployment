#!/bin/sh
CLUSTER_NAME=$(aws eks list-clusters --query clusters --output text | grep analyticscluster)
echo "Cluster name is $CLUSTER_NAME"
IDP_COUNT=0
#$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc" --output text | wc -l)
echo "Found $IDP_COUNT IDPs"
if [ $IDP_COUNT -eq 0 ]; then
  eksctl associate identityprovider -f eks/associate-identity-provider.yaml
fi
