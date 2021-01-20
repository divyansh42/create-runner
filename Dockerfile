FROM alpine:3

ENV HELM_LATEST_VERSION="v3.5.0"
ENV OC_VERSION="4.6.12"
ENV OC_FILENAME="openshift-client-linux.tar.gz"

COPY ./entrypoint.sh /entrypoint.sh

RUN apk add --update ca-certificates \
    && apk add --update -t deps wget git openssl bash \
    && wget -q https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/${OC_FILENAME} \
    && tar ${OC_FILENAME} --exclude='README.md' -C /usr/local/bin -zxf - \
    # && tar zxf ${OC_FILENAME} --exclude='README.md' -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/oc /usr/local/bin/kubectl \
    && mv linux-amd64/helm /usr/local/bin \
    && rm /var/cache/apk/* \
    && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && chmod +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]