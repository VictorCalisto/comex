#!/bin/sh

# Carrega as variáveis do arquivo .env
if [ -f .env ]; then
  source .env
else
  echo "Arquivo .env não encontrado."
  exit 1
fi

# Baixa a imagem do Docker
docker pull $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG

# Aplica os arquivos YAML no Kubernetes
kubectl apply -f $KUBE_CONFIGMAP --namespace=$KUBE_NAMESPACE
kubectl apply -f $KUBE_DB_STATEFULSET --namespace=$KUBE_NAMESPACE
kubectl apply -f $KUBE_DB_SERVICE --namespace=$KUBE_NAMESPACE
kubectl apply -f $KUBE_APP_STATEFULSET --namespace=$KUBE_NAMESPACE
kubectl apply -f $KUBE_APP_SERVICE --namespace=$KUBE_NAMESPACE