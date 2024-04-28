# RSpec
primerio adicione a gem com o comando :
```bash
bundle add rspec-rails -g 'test'
```
Isso vai gerar a gem já no Gemfile na versão correta. Você até pode deixar ai, mas é melhor copiar e colar no grupo de teste.

Agora vamos rodar
```bash
bundle install -j $(nproc)
```
```bash
rails generate rspec:install
```
Modifique o arquivo .rspec na pasta raiz adicionando :
```bash
--format documentation
```
Apague a pasta do mini teste.
```bash
rm -rf test
```
# Trocando database.yml
Lembre-se de trocar o database.yml. Basta ir em config/database.yml e subistituir o arquivo gerado por :
```yaml
default: &default
  adapter: postgresql
  port: 5432
  encoding: unicode
  host: postgres
  database: postgres
  username: postgres
  password:
  pool: 5
  timeout: 5000

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
```
Antes de fazer o deploy para produção coloque uma senha no banco. Coloque essa senha em um arquivo .env para não ser versionado. E atraves de uma variavel de ambiente ecoe essa senha para o database.yml.
# Trocando Dockerfile
Para criar sua aplicacao você está usando um Dockerfile paralelo que gera um container debugavel. Para trocalo basta acrescentar ao seu Dockerfile atual o seguinte final:

```Dockerfile
# Copia as gemas
# A versao do Rails esta fixada no Gemfile
COPY Gemfile* .

# Instala o Bundler
# Fixe a sua versao de bundle
RUN gem install bundler -v
RUN bundler install

# Apaga pid
RUN rm -f /app/tmp/pids/server.pid

# Sobe o Servidor
CMD ["rails", "server", "-b", "0.0.0.0"]
```
e remover a parte:
```Dockerfile
# Instalar o Rails
RUN /bin/bash -l -c "gem install rails"

```
e remover também
```Dockerfile
# Torna o container debugavel
CMD ["sh", "-c", "sleep infinity"]

```
Não se esqueça de fixar a versão do ruby e do bundler. A versão do rails e das demais gems deve ser fixada no Gemfile.

Agora devemos alterar também o docker-entrypoint.sh
# Trocando Entrypoint
Seu entrypoint não deve ser nada muito maior do que isso:
```shell
#!/bin/bash
set -e
rm -f /app/tmp/pids/server.pid
bundle exec rails db:{drop,create,migrate,seed}
exec "$@"
```
em subistitua isso por todo o entrypoint atual.
# Trocando Readme
O atual readme esta para o projeto comex. Como começar um projeto rails. Troque pelo seu projeto, como baixar e codificar nele.
