FROM golang:1.14-alpine

ARG SMTPRELAY_VERSION
WORKDIR /workspace/source
RUN apk add --no-cache git

RUN wget -O /tmp/smtprelay.tar.gz https://github.com/decke/smtprelay/archive/refs/tags/v${SMTPRELAY_VERSION}.tar.gz \
	&& tar xvf /tmp/smtprelay.tar.gz -C /tmp \
	&& cp -r /tmp/smtprelay-${SMTPRELAY_VERSION}/* /workspace/source/ \
	&& go mod download \
	&& CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  		go build -ldflags "-w -extldflags '-static' -X 'main.appVersion=${SMTPRELAY_VERSION}' -X 'main.buildTime=$(date)'"


FROM gcr.io/distroless/base:nonroot

COPY --from=0 /workspace/source/smtprelay /usr/local/bin/smtprelay
ENTRYPOINT [ "smtprelay", "-logfile=/proc/self/fd/1" ]
CMD [ "--help" ]
