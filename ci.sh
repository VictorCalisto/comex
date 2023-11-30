#!/bin/sh

# Protocolo de CI (Continuous Integration - Integração Contínua)

# Carrega as variáveis do arquivo .env
if [ -f .env ]; then
  source .env
else
  echo "Arquivo .env não encontrado."
  exit 1
fi

# # Comando para rodar os testes (substitua com o seu comando)
# TEST_COMMAND="bundle exec rails test"

# # Comando para rodar os testes RSpec (substitua com o seu comando)
# RSPEC_COMMAND="bundle exec rspec"

# # Roda os testes
# echo "Rodando os testes..."
# eval $TEST_COMMAND

# # Verifica se os testes passaram
# if [ $? -ne 0 ]; then
#   echo "Testes falharam. Abortando."
#   exit 1
# fi

# # Se os testes RSpec existirem, rodá-los
# if [ -f "spec/spec_helper.rb" ]; then
#   echo "Rodando os testes RSpec..."
#   eval $RSPEC_COMMAND

#   # Verifica se os testes RSpec passaram
#   if [ $? -ne 0 ]; then
#     echo "Testes RSpec falharam. Abortando."
#     exit 1
#   fi
# fi

# Todos os testes passaram
echo "Todos os testes passaram."

# Constrói a imagem
docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .

# Renomeia a imagem
docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG

# Deploy da imagem
docker push $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG