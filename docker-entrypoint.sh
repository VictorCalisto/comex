#!/bin/sh

# Aguarda um breve período para garantir que o processo principal tenha iniciado
sleep 5

# Verifica se o Gemfile existe no diretório Raiz
if [ -e "./Gemfile" ];
then
  bundle install -j $(nproc) &&
  echo "Já existe um Gemfile no diretório Raiz. Executando create e migrate ..."
  rails db:create
  rails db:migrate
  if rails db:version 2>/dev/null; then
    echo "O banco de dados já esta pronto. Nenhum comando de seed será executado."
  else
    rails db:seed
    echo "Comandos de seed concluídos, o banco de dados está pronto."
  fi
else
  echo "Nenhum Gemfile encontrado. Criando um novo projeto Rails..."

  # Copia os arquivos para a pasta /tmp
  cp Dockerfile docker-compose.yml .gitignore .dockerignore README.md /tmp

  # Crie um novo projeto Rails
  rails new . --css=bootstrap --javascript=esbuild &&
  bundle install -j $(nproc) &&

  # Copia os arquivos da pasta /tmp de volta para a pasta atual, sobrescrevendo os existentes
  cp /tmp/Dockerfile /tmp/docker-compose.yml /tmp/.gitignore /tmp/.dockerignore /tmp/README.md .

  # Limpa a pasta /tmp
  rm /tmp/Dockerfile /tmp/docker-compose.yml /tmp/.gitignore /tmp/.dockerignore /tmp/README.md
  
  echo "Novo projeto Rails foi criado no diretório Raiz."
fi

# Limpa o PID
rm -f /app/tmp/pids/server.pid
echo "Arquivo server.pid deletado. Subindo servidor rails ...."

# Subindo o servidor do rails
exec bundle exec rails s -p 3000 -b 0.0.0.0 &&
rm -f /app/tmp/pids/server.pid

# Executa o comando principal (a aplicação Rails)
exec "$@"

