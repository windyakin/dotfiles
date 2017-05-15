FROM ubuntu:latest

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

# adduser windyakin:windyakin with password 'windyakin'
RUN groupadd -g 1000 windyakin \
   && useradd -g windyakin -G sudo -m -s /bin/bash windyakin \
   && echo 'windyakin:windyakin' | chpasswd

RUN echo 'Defaults visiblepw' >> /etc/sudoers
RUN echo 'windyakin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN git clone https://github.com/Linuxbrew/brew.git /home/windyakin/.linuxbrew \
  && chown -R windyakin:windyakin /home/windyakin/.linuxbrew \
  && sudo -u windyakin echo "PATH=/home/windyakin/.linuxbrew/bin:/home/windyakin/.linuxbrew/sbin:$PATH" > /home/windyakin/.bashrc

ADD . /home/windyakin/dotfiles
RUN chown -R windyakin:windyakin /home/windyakin/dotfiles \
  && sudo -u windyakin -i /home/windyakin/dotfiles/setup.sh

USER windyakin
WORKDIR /home/windyakin/
CMD ["zsh"]
