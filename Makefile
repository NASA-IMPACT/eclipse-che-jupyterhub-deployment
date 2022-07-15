.EXPORT_ALL_VARIABLES:
include .env
export
QUALIFIER ?= analytics
IDP_URL ?= https://cognito-idp.us-west-2.amazonaws.com/us-west-2_OJVQQhBQQ
IDP_USER_CLAIM ?= email
ROUTE53_ACTION ?= UPSERT
CLUSTER_REGION ?= "us-west-2"

install-chectl:
	./scripts/install-chectl.sh

install-eksctl:
	./scripts/install-eksctl.sh

install-dependencies: install-chectl install-eksctl
	npm install --location=global aws-cdk
	python3 -m pip install -e ".[dev,deploy,test]"

bootstrap:
	cdk bootstrap --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

synth:
	cdk synth --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

deploy: deploy-cloud deploy-nginx-ingresscontroller set-dns-record deploy-che

bootstrap-and-deploy: bootstrap deploy

patch-che:
	envsubst < scripts/templates/che-operator-cr-template.yaml > operator-patch.yaml

deploy-che: k8s patch-che
	scripts/configure-idp.sh
	scripts/configure-che.sh

update-che: k8s patch-che
	envsubst < scripts/templates/che-operator-cr-template.yaml > operator-patch.yaml
	chectl server:update --che-operator-cr-patch-yaml=operator-patch.yaml --telemetry=off

deploy-nginx-ingresscontroller: k8s
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	scripts/deploy.sh

destroy: k8s
	scripts/destroy.sh

k8s:
	scripts/connect-k8s.sh

set-dns-record:
	scripts/set-dns-record.sh
	
