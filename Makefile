install-dependencies:
	npm install --location=global aws-cdk
	python3 -m pip install -e ".[dev,deploy,test]"
	curl -sL  https://www.eclipse.org/che/chectl/ > che-install.sh
	chmod +x ./che-install.sh
	./che-install.sh

bootstrap:
	cdk bootstrap --qualifier analytics --toolkit-stack-name analytics

synth:
	cdk synth --qualifier analytics --toolkit-stack-name analytics

deploy: deploy-cloud k8s deploy-nginx-ingresscontroller deploy-che

deploy-all: bootstrap install-che deploy

deploy-che:
	chectl server:deploy --platform k8s --che-operator-cr-patch-yaml=che-operator-cr-patch.yaml --domain analytics.delta-backend.com --skip-oidc-provider-check --telemetry=off
	scripts/setup-che.sh

deploy-nginx-ingresscontroller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	cdk deploy --qualifier analytics --toolkit-stack-name analytics

destroy:
	cdk destroy

k8s:
	scripts/connect-k8s.sh