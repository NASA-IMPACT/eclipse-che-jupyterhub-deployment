#!/bin/sh
scripts/remove-cert-manager-policy.sh
kubectl get services -n ingress-nginx -o yaml > delete-namespace.yaml
kubectl delete -f delete-namespace.yaml
cdk destroy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}
