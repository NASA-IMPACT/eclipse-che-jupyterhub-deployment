#!/bin/bash

SECRET=$(aws secretsmanager get-secret-value --secret-id analytics-certmanager-accesskey-secret --query SecretString --output text)
KEY_ID=$(aws secretsmanager get-secret-value --secret-id analytics-certmanager-accesskeyid --query SecretString --output text)

kubectl create secret generic aws-cert-manager-access-key \
  --from-literal=CLIENT_SECRET=$SECRET -n cert-manager

WORKDIR=$(dirname -- "$0")
aws iam put-user-policy --user-name analytics-certmanager-user --policy-name certmanager-route53-policy --policy-document file://$WORKDIR/certmanager-policy.json

echo "KEY ID IS $KEY_ID"

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: che-certificate-issuer
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: alexbush@developmentseed.org
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - dns01:
        route53:
          region: us-west-2
          accessKeyID: $KEY_ID
          secretAccessKeySecretRef:
            name: aws-cert-manager-access-key
            key: CLIENT_SECRET
EOF