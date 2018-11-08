SHELL=/bin/bash
IMAGE=10.254.0.50:5000/pro-test:v1
NAME="pro-v1"
NAMESPACE="default"
URL="gmt.prov1.me"
IMAGE_PULL_POLICY=Always
MANIFEST=./manifest
SCRIPT=./scripts
MOUNT_PATH=/home/pics

all: build push deploy

build:
	@docker build -t ${IMAGE} .

push:
	@docker push ${IMAGE}

cp:
	@find ${MANIFEST} -type f -name "*.sed" | sed s?".sed"?""?g | xargs -I {} cp {}.sed {}

sed:
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.name}}"?"${NAME}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.namespace}}"?"${NAMESPACE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.image}}"?"${IMAGE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.url}}"?"${URL}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.image.pull.policy}}"?"${IMAGE_PULL_POLICY}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.mount.path}}"?"${MOUNT_PATH}"?g

deploy: export OP=create
deploy: cp sed
	@kubectl ${OP} -f ${MANIFEST}/pvc.yaml
	@kubectl ${OP} -f ${MANIFEST}/staefulset.yaml
	@kubectl ${OP} -f ${MANIFEST}/service.yaml
	@kubectl ${OP} -f ${MANIFEST}/ingress.yaml

clean: export OP=delete
clean:
	-@kubectl ${OP} -f ${MANIFEST}/pvc.yaml
	-@kubectl ${OP} -f ${MANIFEST}/staefulset.yaml
	-@kubectl ${OP} -f ${MANIFEST}/service.yaml
	-@kubectl ${OP} -f ${MANIFEST}/ingress.yaml
	-@rm -f ${MANIFEST}/service.yaml
	-@rm -f ${MANIFEST}/ingress.yaml
	-@rm -f ${MANIFEST}/configmap.yaml
	-@rm -f ${MANIFEST}/controller.yaml

refresh:
	@kubectl ${OP} -f ${MANIFEST}/configmap.yaml
	@kubectl ${OP} -f ${MANIFEST}/configmap.yaml

passwd:
	@${SCRIPT}/get-passwd.sh -n ${NAME} -s ${NAMESPACE}
