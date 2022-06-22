.PHONY: all 
all:
	QUALIFIER="${QUALIFIER:=analytics}"

bootstrap:
	cdk bootstrap --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

synth: all
	cdk synth --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

deploy:
	cdk deploy --qualifier ${QUALIFIER} --toolkit-stack-name ${QUALIFIER}

destroy:
	cdk destroy

k8s:
	scripts/connect-k8s.sh