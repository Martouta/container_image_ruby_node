FROM debian:11.8-slim

ENV HOME="/root"
WORKDIR $HOME

SHELL ["/bin/bash", "-c"]

RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoremove \
    && apt-get install -y -q --no-install-recommends curl ca-certificates vim git \
         gnupg2 wget apt-transport-https software-properties-common \
         libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential ffmpeg \
         libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libpq-dev \
         -o Dpkg::Options::="--force-confold" netcat

ENV RUBY_VERSION 3.2.0
ENV BUNDLER_VERSION 2.2.33
ENV RBENV_VERSION $RUBY_VERSION

ENV NODE_VERSION v18.10.0
ENV NVM_DIR="$HOME/.nvm"
ENV NVM_VERSION v0.38.0
ENV YARN_VERSION 1.22

ENV PATH="${HOME}/.nvm/versions/node/${NODE_VERSION}/bin:${HOME}:${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}"

###### RBENV & RUBY & BUNDLER ######
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash \
    && rbenv init - && echo 'eval "$(rbenv init -)"' >> .bashrc \
    && rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION \
    && echo "eval \"rbenv global $RUBY_VERSION\"" >> .bashrc \
    && gem install bundler:$BUNDLER_VERSION

###### NVM & NODE (with npm) & YARN ######
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && echo "eval \"nvm use $NODE_VERSION\"" >> .bashrc \
    && source .bashrc && npm install -g yarn@$YARN_VERSION
