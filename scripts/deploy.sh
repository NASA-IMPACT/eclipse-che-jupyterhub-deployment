#!/bin/sh
cdk deploy --qualifier "${QUALIFIER}" --toolkit-stack-name "${QUALIFIER}" --require-approval never
