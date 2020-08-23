FROM fedora

RUN dnf install -y git expect
RUN git clone https://github.com/shellspec/shellspec.git \
    && ln -s /shellspec/shellspec /usr/local/bin/
RUN dnf remove -y git

RUN expect -v
RUN shellspec -v

WORKDIR /app

CMD shellspec
