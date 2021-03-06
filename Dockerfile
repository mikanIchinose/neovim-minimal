FROM ubuntu:18.04

ARG VIM_ENABLE_NODE
ARG VIM_ENABLE_PYTHON
ARG VIM_ENABLE_PYTHON3
ARG VIM_ENABLE_PACKER
ARG VIM_ENABLE_DEIN
ARG RIPGREP_VERSION
ARG FD_VERSION
ARG BAT_VERSION

RUN apt-get update  -qq \ 
  && DEBIAN_FRONTEND=noninteractive \
    apt-get install -yq --no-install-recommends \
      curl build-essential git unzip \
      # PPA取得のために必要
      software-properties-common \
      sudo \
      # 環境依存
      ${VIM_ENABLE_NODE:+nodejs npm} \
      ${VIM_ENABLE_PYTHON:+python-dev python-pip} \
      ${VIM_ENABLE_PYTHON3:+python3-dev python3-pip} \
  && apt-get -yq clean \
  && rm -rf /var/lib/apt/lists/*

RUN if [ ! -z "${VIM_ENABLE_NODE}" ]; \
  then \
    npm install -g n && \
    n stable && \
    apt-get purge -yq nodejs npm && \
    rm -rf /root/.cache \
    ; \
  fi

RUN if [ ! -z "${RIPGREP_VERSION}" ]; \
  then \
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb && \
    dpkg -i ripgrep_${RIPGREP_VERSION}_amd64.deb && \
    rm ripgrep_${RIPGREP_VERSION}_amd64.deb \
    ; \
  fi

RUN if [ ! -z "${FD_VERSION}" ]; \
  then \
    curl -LO https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb \
    && dpkg -i fd_${FD_VERSION}_amd64.deb \
    && rm fd_${FD_VERSION}_amd64.deb ; \
  fi

RUN if [ ! -z "${BAT_VERSION}" ]; \
  then \
    curl -LO https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb \
    && dpkg -i bat_${BAT_VERSION}_amd64.deb \
    && rm bat_${BAT_VERSION}_amd64.deb ; \
  fi

RUN add-apt-repository ppa:neovim-ppa/unstable \
  && apt-get update -qq \
  && apt-get install -yq neovim \
  && apt-get -yq clean

# 一般ユーザーの追加(パスワードのいらないsudoユーザーとして登録)
ARG UID=1000 USER_NAME
RUN useradd -m -u ${UID} ${USER_NAME} \
  && gpasswd -a ${USER_NAME} sudo \
  && echo "${USER_NAME}:password" | chpasswd \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV HOME_DIRECTORY="/home/${USER_NAME}" 
ENV DEINVIM_DIRECTORY=".cache/dein"
USER ${UID}
WORKDIR ${HOME_DIRECTORY}

# install python neovim client
RUN if [ ! -z "${VIM_ENEBLE_PYTHON_3}" ]; \
  then \
    python3 -m pip install --upgrade pip setuptools \
    && python3 -m pip install --user pynvim \
    && sudo rm -rf /root/.cache ; \
  fi

RUN mkdir -p ${HOME_DIRECTORY}/.config/nvim

RUN echo "dein ${VIM_ENABLE_DEIN}, packer: ${VIM_ENABLE_PACKER}"
RUN [ -z "${VIM_ENABLE_DEIN}" ] \
  || curl -sf \
    https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
    | sh -s "${HOME_DIRECTORY}/${DEINVIM_DIRECTORY}"

RUN [ -z "$VIM_ENABLE_PACKER" ] \
  || git clone https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

LABEL maintainer="mikan.ichinose <maruisansmai@gmail.com>"

# ENTRYPOINT ["nvim"]
