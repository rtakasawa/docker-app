# ベースとなるイメージを指定する。
# 指定したイメージの上に、他のレイヤーが重なる。
FROM ruby:2.6.5

# パッケージをインストールするコマンド
RUN apt-get update
# インストールするパッケージをかく
# コンテナを立ててrailsを起動した際にエラーが出たら必要なパッケージを追加して調整する。
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y nodejs
RUN apt-get install -y postgresql-client
RUN apt-get install -y yarn

# コンテナ内にdocker-appディレクトリがない場合は、
# docker-appディレクトリを作り,各種命令を実行する際のカレントディレクトリに指定する。
WORKDIR /docker-app
# hostのGemfile,Gemfile.lockをdocker-appディレクトリにコピーする
COPY Gemfile Gemfile.lock /docker-app/
RUN bundle install