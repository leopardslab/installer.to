FROM centos:7

RUN yum install -y git expect
RUN git clone https://github.com/shellspec/shellspec.git \
    && ln -s /shellspec/shellspec /usr/local/bin/
RUN yum remove -y git

RUN expect -v
RUN shellspec -v

WORKDIR /app

CMD shellspec
