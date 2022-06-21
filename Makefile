bootstrap:
	cdk bootstrap --qualifier analytics --toolkit-stack-name analytics

synth:
	cdk synth --qualifier analytics --toolkit-stack-name analytics

deploy:
	cdk deploy --qualifier analytics --toolkit-stack-name analytics

k8s:
	scripts/connect-k8s.sh