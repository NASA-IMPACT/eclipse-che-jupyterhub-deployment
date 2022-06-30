QUALIFIER ?= "analytics"

install-che:
	curl -sL  https://www.eclipse.org/che/chectl/ > che-install.sh
	chmod +x ./che-install.sh
	./che-install.sh

install-dependencies: install-che
	npm install --location=global aws-cdk
	python3 -m pip install -e ".[dev,deploy,test]"

bootstrap:
	export QUALIFIER=${QUALIFIER}; cdk bootstrap --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

synth:
	export QUALIFIER=${QUALIFIER}; cdk synth --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

deploy: deploy-cloud k8s deploy-nginx-ingresscontroller deploy-che

deploy-all: bootstrap install-che deploy

#Ref: https://github.com/eclipse/che/issues/21160#issuecomment-1061972560
deploy-che:
	chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=che-operator-cr-patch.yaml --domain analyticsveda.delta-backend.com --skip-oidc-provider-check --telemetry=off
	scripts/setup-che.sh

update-che:
	chectl server:update --che-operator-cr-patch-yaml=che-operator-cr-patch.yaml --telemetry=off

deploy-nginx-ingresscontroller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	export QUALIFIER=${QUALIFIER}; cdk deploy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}
	eksctl associate identityprovider -f eks/associate-identity-provider.yaml

destroy:
	export QUALIFIER=${QUALIFIER}; cdk destroy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

k8s:
	scripts/connect-k8s.sh
