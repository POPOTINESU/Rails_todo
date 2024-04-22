# syntax = docker/dockerfile:1

# Rubyのバージョンはプロジェクトに合わせてください
ARG RUBY_VERSION=3.2.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Railsアプリの作業ディレクトリ
WORKDIR /backend

# 開発環境の設定
ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=""

# 開発用のパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config curl

# Gemファイルをコピー
COPY Gemfile Gemfile.lock ./

# Gemをインストール
RUN bundle install

# アプリケーションコードをコピー
COPY . .

# ユーザーの追加は、セキュリティの観点からも開発環境で推奨されますが、
# 開発の柔軟性を考慮して、rootユーザーでの作業を許可することも一般的です。
# 適宜変更してください。
# RUN useradd rails --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER rails:rails

# データベースの準備やサーバーの起動を行うエントリーポイント
ENTRYPOINT ["/backend/bin/docker-entrypoint"]

# デフォルトでRailsサーバーを起動
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
