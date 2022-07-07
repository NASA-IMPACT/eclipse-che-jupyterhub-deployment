#!/bin/sh
scripts/remove-cert-manager-policy.sh
export ROUTE53_ACTION="DELETE"; scripts/set-dns-record.sh
kubectl get services -n ingress-nginx -o yaml > delete-namespace.yaml
kubectl delete -f delete-namespace.yaml
cdk destroy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}
