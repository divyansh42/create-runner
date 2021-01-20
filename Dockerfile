FROM alpine

ENV HELM_LATEST_VERSION="v3.5.0"
# ENV OPENSHIFT_VERSION="4.6"

COPY ./entrypoint.sh /entrypoint.sh

RUN apk add --update ca-certificates \
    && apk add --update -t deps wget git openssl bash \
    && wget -q https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    # && wget -q https://mirror.openshift.com/pub/openshift-v4/clients/oc/${OPENSHIFT_VERSION}/linux/oc.tar.gz | \
        # tar --exclude='README.md' -C /usr/local/bin -zxf - \
    && mv linux-amd64/helm /usr/local/bin \
    && rm /var/cache/apk/* \
    && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    # && chmod +x /usr/local/bin/oc /usr/local/bin/kubectl \
    && chmod +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]