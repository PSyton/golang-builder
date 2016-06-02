FROM golang:1.6-alpine
MAINTAINER Alex Peters <info@alexanderpeters.de>

RUN apk update && apk add docker 

# Install Docker binary
# RUN wget -nv https://get.docker.com/builds/Linux/x86_64/docker-1.5.0 -O /usr/bin/docker && \
#   chmod +x /usr/bin/docker

RUN go get github.com/pwaller/goupx \
  && go get golang.org/x/tools/cmd/cover \
  && go get -u github.com/golang/lint/golint \
  && go get github.com/kisielk/errcheck


RUN wget https://raw.githubusercontent.com/pote/gpm/v1.3.2/bin/gpm -O /usr/local/bin/gpm && \
  chmod +x /usr/local/bin/gpm


VOLUME /src
WORKDIR /src


COPY build_environment.sh /
COPY build.sh /
RUN echo "machine github.com login $GITHUB_TOKEN" >/root/.netrc

ENV GOMAXPROCS=2
ENV GORACE="halt_on_error=1"

ENTRYPOINT ["/build.sh"]
