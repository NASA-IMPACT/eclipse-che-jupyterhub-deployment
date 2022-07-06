#!/bin/sh
CLUSTER_NAME=$(aws eks list-clusters --query clusters --output text | grep "${QUALIFIER}-analyticscluster")
echo $CLUSTER_NAME
CONFIG=$(aws cloudformation describe-stacks --stack-name "${QUALIFIER}-analytics-stack" --query 'Stacks[0].Outputs[?contains(OutputKey,`ConfigCommand`)].OutputValue' --output=text)
TOKEN=$(aws cloudformation describe-stacks --stack-name "${QUALIFIER}-analytics-stack" --query 'Stacks[0].Outputs[?contains(OutputKey,`TokenCommand`)].OutputValue' --output=text)
$CONFIG
$TOKEN
