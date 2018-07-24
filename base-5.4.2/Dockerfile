FROM zshusers/zsh-5.4.2:latest

RUN \
    apt update && \
    DEBAIN_FRONTEND=noninteractive apt install -y \
    curl \
    git \
    vim \
    nodejs \
    jq \
    sudo \
    locales

RUN adduser --shell /bin/zsh --gecos 'tom' --disabled-password tom
RUN locale-gen "en_US.UTF-8"

USER tom
WORKDIR /home/tom
ENV LANG=en_US.UTF-8
ENV TERM=xterm-256color
ENV DEFUALT_USER=tom

RUN git clone https://github.com/denysdovhan/spaceship-prompt.git --recursive

COPY zshrc .zshrc
