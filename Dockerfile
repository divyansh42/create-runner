FROM alpine
ENV HELM_LATEST_VERSION="v3.5.0"
COPY ./entrypoint.sh /entrypoint.sh
RUN apk add --update ca-certificates \
    && apk add --update -t deps wget git openssl bash \
    && wget -q https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin \
    && rm /var/cache/apk/* \
    && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz && \
    chmod +x entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]