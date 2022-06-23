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

deploy: deploy-cloud k8s deploy-che

deploy-che:
	chectl server:deploy --platform k8s --domain test.test

deploy-cloud:
	cdk deploy --qualifier analytics --toolkit-stack-name analytics

destroy:
	cdk destroy

k8s:
	scripts/connect-k8s.sh