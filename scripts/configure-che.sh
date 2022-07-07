#!/bin/bash
chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=operator-patch.yaml --domain "${QUALIFIER}-analytics.delta-backend.com" --skip-oidc-provider-check --telemetry=off

CERTMANAGER_KEY_ID=$(aws secretsmanager get-secret-value --secret-id "certmanager-accesskeyid-${QUALIFIER}" --query SecretString --output text)
CERTMANAGER_SECRET=$(aws secretsmanager get-secret-value --secret-id "certmanager-accesskey-secret-${QUALIFIER}" --query SecretString --output text)

envsubst < eks/aws-cert-manager-access-key.secret.yaml > eks/secrets-substs.yaml
kubectl apply -f eks/secrets-substs.yaml

WORKDIR=$(dirname -- "$0")
aws iam put-user-policy --user-name "certmanager-user-${QUALIFIER}" --policy-name certmanager-route53-policy --policy-document file://$WORKDIR/certmanager-policy.json

echo "KEY ID IS $CERTMANAGER_KEY_ID"

cat <<EOF | kubectl apply -f -
---
apiVersion: cert-manager.io/v1
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
          accessKeyID: $CERTMANAGER_KEY_ID
          secretAccessKeySecretRef:
            name: aws-cert-manager-access-key
            key: AWS_SECRET_ACCESS_KEY
EOF
