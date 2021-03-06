FROM golang:1.15.6

RUN go get github.com/Masterminds/glide
RUN go get github.com/jteeuwen/go-bindata/...
RUN go get -u -v golang.org/x/lint/golint
RUN go get github.com/kisielk/errcheck
RUN go get github.com/client9/misspell/cmd/misspell

# Which docker version to test on
ARG DOCKER_VERSION=1.10.1

# Download docker
RUN set -ex; \
    curl https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION} -o /usr/local/bin/docker-${DOCKER_VERSION}; \
    chmod +x /usr/local/bin/docker-${DOCKER_VERSION}

# Set the default Docker to be run
RUN ln -s /usr/local/bin/docker-${DOCKER_VERSION} /usr/local/bin/docker

WORKDIR /go/src/github.com/containous/traefik

COPY glide.yaml glide.yaml
COPY glide.lock glide.lock
RUN glide install -v

COPY integration/glide.yaml integration/glide.yaml
COPY integration/glide.lock integration/glide.lock
RUN cd integration && glide install

COPY . /go/src/github.com/containous/traefik
