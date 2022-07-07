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

deploy: deploy-cloud k8s deploy-nginx-ingresscontroller deploy-che

deploy-all: bootstrap install-chectl deploy

#Ref: https://github.com/eclipse/che/issues/21160#issuecomment-1061972560
deploy-che:
	export IDP_USER_CLAIM=${IDP_USER_CLAIM}; export IDP_URL=${IDP_URL}; envsubst < che-operator-cr-patch.yaml > operator-patch-envs.yaml
	chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=operator-patch-envs.yaml --domain analytics.delta-backend.com --skip-oidc-provider-check --telemetry=off
	scripts/configure-che.sh

update-che:
	export IDP_USER_CLAIM=${IDP_USER_CLAIM}; export IDP_URL=${IDP_URL}; envsubst < che-operator-cr-patch.yaml > operator-patch-envs.yaml
	chectl server:update --che-operator-cr-patch-yaml=operator-patch-envs.yaml --telemetry=off

deploy-nginx-ingresscontroller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	export QUALIFIER=${QUALIFIER}; cdk deploy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}
	export IDP_URL=${IDP_URL}; export IDP_USER_CLAIM=${IDP_USER_CLAIM}; scripts/configure-idp.sh

destroy:
	export QUALIFIER=${QUALIFIER}; make k8s
	export QUALIFIER=${QUALIFIER}; scripts/remove-cert-manager-policy.sh
	kubectl get services -n ingress-nginx -o yaml > delete-namespace.yaml
	kubectl delete -f delete-namespace.yaml
	export QUALIFIER=${QUALIFIER}; cdk destroy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

k8s:
	scripts/connect-k8s.sh
