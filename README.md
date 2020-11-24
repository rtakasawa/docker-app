# Docker＋RailsのWEBアプリ環境構築
出典：米国AI開発者がゼロから教えるDocker講座

## 環境
- Ruby2.6.5
- Rails5.2.4
- Postgresql

## 手順
1. 対象ディレクトリにDockerfileを作成する \
Dockerfileのコード↓
```Dockerfile
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
```

2. 対象ディレクトリにGemfile、Gemfile.lockを作成する\
Gemfileのコード↓
```Gemfile
source 'https://rubygems.org'
gem 'rails', '~> 5.2.4'
```
※Gemfile.lockは空

3. docker-composeを使って、コンテナを起動するため、対象ディレクトリにdocker-compose.ymlを作成する。 \
docker-composeのメリット
- 複数のコンテナを同時に起動できる。
- docker関連のコマンドを予めdocker-compose.ymlに書くことで、実行コマンドが短くて済む

docker-compose.ymlのコード↓
```docker-compose.yml
# Dockercomposeはコンテナをどのように起動するかを書く

# Dockercomposeのファイル書きますよ宣言
version: '3'

services:
  # コンテナ毎にserviceの下にネストして書く
  web:
    # カレントディレクトリーにあるDockerfileをbuildする
    build: .
    # pabulishするポートを書く。
    ports:
      - '3000:3000'
    # マウントするディレクトリを指定する
    volumes:
      - '.:/docker-app'
    tty: true
    stdin_open: true
```

4. ` docker-compose up -d `コマンドで、docker-compose.ymlを読み取り、イメージ＆コンテナ作成	。全コンテナを一括起動する。 \
※ -d(デタッチド・モード)
バックグラウンドでコンテナを実行し、新しいコンテナ名を表示。

5. ` docker-compose ps `コマンドで、コンテナがupされているか確認する。
```
$ docker-compose ps
      Name         Command   State           Ports
-----------------------------------------------------------
docker-app_web_1   irb       Up      0.0.0.0:3000->3000/tcp
```

6. ` docker-compose exec web bash `コマンドで、コンテナに入る。
```
$ docker-compose exec web bash
root@a81e00960399:/docker-app#
```

7. ` rails new . --force --database=postgresql --skip-bundle `コマンドでアプリを作る。 \
- docker-compose.ymlでマウントしているディレクトリにアプリ関連のファイル等が作成される。
- Gemfileの中身が更新される。

8. Gemfileの内容をアプリに反映するためにインストールする必要がある。 \
そのため、dockerfileを再度読み込むので、





