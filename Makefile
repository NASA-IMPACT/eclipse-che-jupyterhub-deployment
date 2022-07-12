QUALIFIER ?= "analytics"
IDP_URL ?= "https://cognito-idp.us-west-2.amazonaws.com/us-west-2_OJVQQhBQQ"
IDP_USER_CLAIM ?= "email"

install-chectl:
	./scripts/install-chectl.sh

install-eksctl:
	./scripts/install-eksctl.sh

install-dependencies: install-chectl install-eksctl
	npm install --location=global aws-cdk
	python3 -m pip install -e ".[dev,deploy,test]"

bootstrap:
	export QUALIFIER=${QUALIFIER}; cdk bootstrap --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

synth:
	export QUALIFIER=${QUALIFIER}; cdk synth --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

deploy: deploy-cloud configure-idp deploy-nginx-ingresscontroller set-dns-record deploy-che

bootstrap-and-deploy: bootstrap deploy

configure-idp: k8s
	export IDP_USER_CLAIM=${IDP_USER_CLAIM}; export IDP_URL=${IDP_URL}; scripts/configure-idp.sh

patch-che:
	export IDP_USER_CLAIM=${IDP_USER_CLAIM}; export IDP_URL=${IDP_URL}; envsubst < scripts/templates/che-operator-cr-template.yaml > operator-patch.yaml

deploy-che: k8s patch-che
	export QUALIFIER=${QUALIFIER}; scripts/configure-che.sh

update-che: k8s patch-che
	export IDP_USER_CLAIM=${IDP_USER_CLAIM}; export IDP_URL=${IDP_URL}; envsubst < scripts/templates/che-operator-cr-template.yaml > operator-patch.yaml
	chectl server:update --che-operator-cr-patch-yaml=operator-patch.yaml --telemetry=off

deploy-nginx-ingresscontroller: k8s
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	export IDP_URL=${IDP_URL}; export IDP_USER_CLAIM=${IDP_USER_CLAIM}; export QUALIFIER=${QUALIFIER}; scripts/deploy.sh

destroy: k8s
	export QUALIFIER=${QUALIFIER}; scripts/destroy.sh

k8s:
	export QUALIFIER=${QUALIFIER}; scripts/connect-k8s.sh

set-dns-record:
	export ROUTE53_ACTION="UPSERT"; scripts/set-dns-record.sh
	
