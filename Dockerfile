FROM ubuntu:latest

ARG USERNAME

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list

RUN apt-get update \
   && apt-get dist-upgrade -y \
   && apt-get install -y sudo git zsh software-properties-common build-essential curl file python-setuptools ruby \
   && rm -rf /var/lib/apt/lists/*

# For jp_JP.UTF-8
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

# set timezone for JST
RUN echo "Asia/Tokyo" > /etc/timezone && \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

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
