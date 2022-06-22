#!/bin/sh
CLUSTER_NAME=$(aws eks list-clusters --query clusters --output text | grep analyticscluster)
echo $CLUSTER_NAME
aws eks update-kubeconfig --region us-east-1 --name $CLUSTER_NAME
aws eks get-token --region us-east-1 --cluster-name $CLUSTER_NAME