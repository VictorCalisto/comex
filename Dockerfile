FROM ruby

# Atualizar os pacotes e instalar as dependências
RUN apt-get update -y
RUN apt-get install -y curl gpg
RUN apt-get install -y curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev

# Instalar o Rails 7.1.1
RUN /bin/bash -l -c "gem install rails"

# # Instalar o Node.js 20  // Só vai ser preciso se for mexer no frontend
# RUN apt-get update -y && \
#     apt-get install -y ca-certificates curl gnupg && \
#     curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
#     NODE_MAJOR=20 && \
#     echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
#     apt-get update -y && \
#     apt-get install -y nodejs

# Define o diretório de trabalho
WORKDIR /app

# Limpar o cache do apt-get e outros arquivos temporários
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Tratamento de erros
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["sh","/usr/local/bin/docker-entrypoint.sh"]