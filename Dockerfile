FROM ruby:2.5.0-alpine

ENV APP_PATH /var/app

WORKDIR $APP_PATH

COPY process.rb ./
COPY movimentacao_de_contas.rb ./
COPY contas.csv ./
COPY transacoes.csv ./
