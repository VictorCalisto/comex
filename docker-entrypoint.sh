#!/bin/sh

# Aguarda um breve período para garantir que o processo principal tenha iniciado
sleep 5

# Diretório onde você deseja verificar a existência do Gemfile.lock
diretorio="/app"

# Verifica se o Gemfile.lock existe no diretório
if [ -e "$diretorio/Gemfile.lock" ];
then
  bundle install &&
  echo "Já existe um Gemfile.lock no diretório $diretorio."
  rails db:create
  rails db:migrate
  if rails db:version 2>/dev/null; then
    echo "O banco de dados já contém informações. Nenhum comando de seed será executado."
  else
    rails db:seed
    echo "Comandos de seed concluídos, o banco de dados está configurado."
  fi
else
  echo "Nenhum Gemfile.lock encontrado. Criando um novo projeto Rails..."

  # Copia os arquivos para a pasta /tmp
  cp Dockerfile docker-compose.yml .gitignore .dockerignore docker-entrypoint.sh /tmp

  # Crie um novo projeto Rails
  rails new . &&
  bundle install &&

  # Copia os arquivos da pasta /tmp de volta para a pasta atual, sobrescrevendo os existentes
  cp /tmp/Dockerfile /tmp/docker-compose.yml /tmp/.gitignore /tmp/.dockerignore /tmp/docker-entrypoint.sh .

  # Limpa a pasta /tmp
  rm /tmp/Dockerfile /tmp/docker-compose.yml /tmp/.gitignore /tmp/.dockerignore /tmp/docker-entrypoint.sh
  
  echo "Novo projeto Rails foi criado no diretório $diretorio."
fi

# Limpa o PID
rm -f /app/tmp/pids/server.pid
echo "Arquivo server.pid deletado. Subindo servidor rails ...."

# Subindo o servidor do rails
exec bundle exec rails s -p 3000 -b 0.0.0.0

# Executa o comando principal (a aplicação Rails)
exec "$@"

