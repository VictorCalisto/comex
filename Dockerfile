# Fixe a sua versao de rubi ao subir o projeto
FROM ruby

# Atualizar os pacotes e instalar as dependências
RUN apt-get update -y

# Instala dependencias
RUN apt-get install -qy --no-install-recommends \
    curl \
    gpg \
    autoconf  \
    bison  \
    build-essential  \
    libssl-dev  \
    libyaml-dev  \
    libreadline6-dev  \
    zlib1g-dev  \
    libncurses5-dev  \
    libffi-dev  \
    libgdbm6  \
    libgdbm-dev \
    libpq-dev \
    postgresql-client

# Instalar o Rails
RUN /bin/bash -l -c "gem install rails"

# Define o diretório de trabalho
WORKDIR /app

# Limpar o cache do apt-get e outros arquivos temporários
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Tratamento de erros
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["sh","/usr/local/bin/docker-entrypoint.sh"]

# Torna o container debugavel
CMD ["sh", "-c", "sleep infinity"]