#!/bin/bash
POLICIES=$(aws iam list-user-policies --user-name "certmanager-user-${QUALIFIER}" --output text | wc -l)
if [ $POLICIES -gt 0 ]; then
  aws iam delete-user-policy --user-name "certmanager-user-${QUALIFIER}" --policy-name certmanager-route53-policy
else
  echo "No dangling policies found"
fi
