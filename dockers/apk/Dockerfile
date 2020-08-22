FROM alpine

RUN apk add git expect
RUN git clone https://github.com/shellspec/shellspec.git \
    && ln -s /shellspec/shellspec /usr/local/bin/
RUN apk del git

RUN expect -v
RUN shellspec -v

WORKDIR /app

CMD shellspec
