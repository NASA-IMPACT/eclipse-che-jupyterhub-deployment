#!/bin/bash
export ROUTE53_HOSTED_ZONE="Z005660034LMNOJCPIGWF"
export ELB_HOSTNAME=$(kubectl get service ingress-nginx-controller --namespace=ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
envsubst < scripts/templates/route53-record-template.json > scripts/route53-record-subst.json
aws route53 change-resource-record-sets --hosted-zone-id ${ROUTE53_HOSTED_ZONE} --change-batch file://scripts/route53-record-subst.json --no-cli-pager
