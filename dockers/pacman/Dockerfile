FROM archlinux

RUN pacman -Sy git expect --noconfirm
RUN git clone https://github.com/shellspec/shellspec.git \
    && ln -s /shellspec/shellspec /usr/local/bin/
RUN pacman -Rsn git --noconfirm

RUN expect -v
RUN shellspec -v

WORKDIR /app

CMD shellspec
