FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y curl git expect
RUN git clone https://github.com/shellspec/shellspec.git \
    && mkdir $HOME/bin/ \
    && ln -s /shellspec/shellspec /usr/local/bin/
RUN apt remove git -y

RUN shellspec -v
WORKDIR /app
CMD shellspec
