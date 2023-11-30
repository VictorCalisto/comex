#!/bin/sh

# Protocolo de CD (Continuous Delivery - Entrega Contínua)

# Carrega as variáveis do arquivo .env
if [ -f .env ]; then
  source .env
else
  echo "Arquivo .env não encontrado."
  exit 1
fi

# Baixa a imagem do Docker
# docker pull $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG # testei e deu certo

docker pull aluracursos/sistema-noticias:1 #apagar depois imagem back
docker pull aluracursos/portal-noticias:1 #apagar depois imagem front
docker pull aluracursos/mysql-db:1 #apagar depois imagem banco

# Aplica os arquivos YAML no Kubernetes
kubectl apply -f ./kubernetes/env-configmap.yaml # configmap = variaveis de ambiente
kubectl apply -f ./kubernetes/local-storage.yaml # storange = gerenciador de volumes

kubectl apply -f ./kubernetes/db-statefulset.yaml # statefulset = pod + replicaset + deployment + volume (aceita volume, nao tem volume proprio, eu tentei)
kubectl apply -f ./kubernetes/db-service-cluster.yaml # clusterIP = servico com porta interna, nao eh acessivel externamente. aponta para o pod
kubectl apply -f ./kubernetes/db-pv.yaml # volume = onde armazena as coisas.
kubectl apply -f ./kubernetes/db-pvc.yaml # claim = tipo um servico que aponta para o volume.

kubectl apply -f ./kubernetes/app-back-statefulset.yaml
kubectl apply -f ./kubernetes/app-back-service-load.yaml
kubectl apply -f ./kubernetes/app-back-imagens-pv.yaml
kubectl apply -f ./kubernetes/app-back-imagens-pvc.yaml
kubectl apply -f ./kubernetes/app-back-sessao-pv.yaml
kubectl apply -f ./kubernetes/app-back-sessao-pvc.yaml

kubectl apply -f ./kubernetes/app-front-deployment.yaml # deploymente = pod + replicaset. CUIDADO sem volume.
kubectl apply -f ./kubernetes/app-front-service-load.yaml # LoadBance = servico com porta externa que aponta para o pod. eh acessivel por fora e por dentro.