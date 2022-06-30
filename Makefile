QUALIFIER ?= "analytics"

install-dependencies:
	npm install --location=global aws-cdk
	python3 -m pip install -e ".[dev,deploy,test]"
	curl -sL  https://www.eclipse.org/che/chectl/ > che-install.sh
	chmod +x ./che-install.sh
	./che-install.sh

bootstrap:
	export QUALIFIER=${QUALIFIER}; cdk bootstrap --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

synth:
	export QUALIFIER=${QUALIFIER}; cdk synth --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

deploy: deploy-cloud k8s deploy-nginx-ingresscontroller deploy-che

deploy-all: bootstrap install-che deploy

deploy-che:
	envsubst < che-operator-cr-patch.yaml > operator-patch-envs.yaml
	chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=operator-patch-envs.yaml --domain analytics.delta-backend.com --skip-oidc-provider-check --telemetry=off
	scripts/setup-che.sh

deploy-nginx-ingresscontroller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	export QUALIFIER=${QUALIFIER}; cdk deploy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

destroy:
	export QUALIFIER=${QUALIFIER}; cdk destroy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

k8s:
	scripts/connect-k8s.sh
