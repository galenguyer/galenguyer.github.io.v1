FROM docker.io/library/ruby:3.0.1-buster AS builder

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN bundle exec jekyll build

FROM docker.io/galenguyer/nginx:alpine3.13.5-1.21.0

COPY --from=builder /usr/src/app/_site/ /usr/share/nginx/html/
