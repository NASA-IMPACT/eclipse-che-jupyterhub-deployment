install-che:
	curl -sL  https://www.eclipse.org/che/chectl/ > scripts/che-install.sh
	chmod +x ./scripts/che-install.sh
	./scripts/che-install.sh

install-dependencies:
	echo "TODO!"

bootstrap:
	cdk bootstrap --qualifier analytics --toolkit-stack-name analytics

synth:
	cdk synth --qualifier analytics --toolkit-stack-name analytics

deploy: deploy-cloud k8s deploy-nginx-ingresscontroller deploy-che

deploy-che:
	chectl server:deploy --platform k8s --domain test.test --skip-oidc-provider-check --telemetry=off

deploy-nginx-ingresscontroller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

deploy-cloud:
	cdk deploy --qualifier analytics --toolkit-stack-name analytics

destroy:
	cdk destroy

k8s:
	scripts/connect-k8s.sh