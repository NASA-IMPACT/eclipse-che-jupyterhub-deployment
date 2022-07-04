QUALIFIER ?= "analytics"

install-che:
	curl -sL  https://www.eclipse.org/che/chectl/ > che-install.sh
	chmod +x ./che-install.sh
	./che-install.sh
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	mv /tmp/eksctl /usr/local/bin

install-dependencies: install-che install-eksctl
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
	envsubst < che-operator-cr-patch.yaml > operator-patch-envs.yaml
	chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=operator-patch-envs.yaml --domain analytics.delta-backend.com --skip-oidc-provider-check --telemetry=off
	scripts/setup-che.sh

update-che:
	chectl server:update --che-operator-cr-patch-yaml=che-operator-cr-patch.yaml --telemetry=off

deploy-nginx-ingresscontroller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	export QUALIFIER=${QUALIFIER}; cdk deploy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}
	export IDP_URL=${IDP_URL}; export IDP_USER_CLAIM=${IDP_USER_CLAIM}; scripts/setup-idp.sh

destroy:
	export QUALIFIER=${QUALIFIER}; cdk destroy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

k8s:
	scripts/connect-k8s.sh
