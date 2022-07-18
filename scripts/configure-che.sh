#!/bin/sh

CHE_STATUS=$(chectl server:status --telemetry=off)
COMMAND_STATUS=$?

[ $COMMAND_STATUS -eq 0 ] && chectl server:update --che-operator-cr-patch-yaml=operator-patch.yaml --telemetry=off -y

chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=operator-patch.yaml --domain "${QUALIFIER}-analytics.delta-backend.com" --skip-oidc-provider-check --telemetry=off

export CERTMANAGER_KEY_ID=$(aws secretsmanager get-secret-value --secret-id "certmanager-accesskeyid-${QUALIFIER}" --query SecretString --output text)
export CERTMANAGER_SECRET=$(aws secretsmanager get-secret-value --secret-id "certmanager-accesskey-secret-${QUALIFIER}" --query SecretString --output text)

envsubst < scripts/templates/aws-cert-manager-access-key.secret.yaml > secrets-substs.yaml
kubectl apply -f secrets-substs.yaml

WORKDIR=$(dirname -- "$0")
aws iam put-user-policy --user-name "certmanager-user-${QUALIFIER}" --policy-name certmanager-route53-policy --policy-document file://$WORKDIR/templates/certmanager-policy.json

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
