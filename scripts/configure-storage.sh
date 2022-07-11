#!/bin/sh
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
CLUSTER_NAME=$(aws eks list-clusters --query "clusters[?contains(@, 'clusteranalyticscluster$QUALIFIER')]" --output text)
GENERATED_ARN="arn:aws:iam::${ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole"
echo "Cluster name is $CLUSTER_NAME"
eksctl create addon --name aws-ebs-csi-driver \
                    --cluster $CLUSTER_NAME \
                    --service-account-role-arn $GENERATED_ARN