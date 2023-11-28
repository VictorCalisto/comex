#!/bin/sh

# Carrega as variáveis do arquivo .env
if [ -f .env ]; then
  source .env
else
  echo "Arquivo .env não encontrado."
  exit 1
fi

# Baixa a imagem do Docker
# docker pull $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG # testei e deu certo
docker pull aluracursos/sistema-noticias:1 #apagar depois
docker pull aluracursos/mysql-db:1 #apagar depois
# Aplica os arquivos YAML no Kubernetes
kubectl apply -f $KUBE_CONFIGMAP
kubectl apply -f $KUBE_DB_STATEFULSET
kubectl apply -f $KUBE_DB_SERVICE
kubectl apply -f $KUBE_APP_STATEFULSET
kubectl apply -f $KUBE_APP_SERVICE