FROM curlimages/curl AS fetch

ARG SMTPRELAY_VERSION
RUN curl -L -o /tmp/smtprelay.tar.gz \
		https://github.com/decke/smtprelay/releases/download/v${SMTPRELAY_VERSION}/smtprelay-v${SMTPRELAY_VERSION}-linux-amd64.tar.gz \
	&& mkdir /tmp/out \
	&& tar xvf /tmp/smtprelay.tar.gz -C /tmp/out

FROM gcr.io/distroless/base:nonroot

COPY --from=fetch /tmp/out/smtprelay /usr/local/bin/smtprelay
ENTRYPOINT [ "smtprelay", "-logfile=/proc/self/fd/1" ]
CMD [ "--help" ]
