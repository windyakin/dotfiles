FROM ubuntu:20.04

ARG USERNAME=windyakin

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

RUN apt-get update \
   && apt-get upgrade -y \
   && apt-get install -y --no-install-recommends \
    sudo \
    git \
    zsh \
    software-properties-common \
    build-essential \
    curl \
    ca-certificates \
    file \
    python-setuptools \
    ruby \
    language-pack-ja \
    tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
  && echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

# adduser ${USERNAME}:${USERNAME} with password '${USERNAME}'
RUN groupadd -g 1000 ${USERNAME} \
   && useradd -g ${USERNAME} -G sudo -m -s /bin/bash ${USERNAME} \
   && echo "${USERNAME}:${USERNAME}" | chpasswd

RUN echo "Defaults visiblepw" >> /etc/sudoers
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN git clone https://github.com/Linuxbrew/brew.git /home/${USERNAME}/.linuxbrew \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.linuxbrew \
  && sudo -u ${USERNAME} echo "PATH=/home/${USERNAME}/.linuxbrew/bin:/home/${USERNAME}/.linuxbrew/sbin:$PATH" > /home/${USERNAME}/.bashrc

ADD . /home/${USERNAME}/dotfiles
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/dotfiles \
  && sudo -u ${USERNAME} -i /home/${USERNAME}/dotfiles/setup.sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}/
CMD ["zsh"]
