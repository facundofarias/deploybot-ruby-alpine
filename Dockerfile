FROM ruby:2.7.6-alpine

LABEL maintainer="facundo@saas.group"

# Install the required dependencies on Linux Alpine
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
      bash \
      build-base \
      chromium \
      chromium-chromedriver \
      curl \
      git \
      vim \
      libpq \
      nodejs \
      npm \
      yarn \
      tzdata \
      zip unzip \
      mysql \
      mysql-dev \
      mysql-client \
      cmake \
      icu-dev \
      findutils \
      git \
      ruby \
      ruby-rugged \
      ruby-json \
      ruby-dev \
      openssh-client \
      openssl \
      openssl-dev && \
    curl -L https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz | tar xz -C /usr/local/bin

# Install the required version of bundler
RUN gem install bundler:1.17.3 --no-document

# Define where our application will live inside the image
RUN mkdir /deploybot
WORKDIR /deploybot

# Config repository
ONBUILD COPY lib ./lib
ONBUILD COPY Gemfile* ./
ONBUILD RUN bundle install --jobs=3 --retry=3

ONBUILD COPY . ./
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
