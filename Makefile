SHELL=/bin/bash
IMAGE=10.254.0.50:5000/tomcat-tmp:7.0.77-jre8
MANIFEST=./manifest

all: build push deploy

build:
	@docker build -t ${IMAGE} .

push:
	@docker push ${IMAGE}

deploy: export OP=create 
deploy: 
	@kubectl ${OP} -f ${MANIFEST}/.

clean: OP=delete
clean:
	@kubectl ${OP} -f ${MANIFEST}/.
