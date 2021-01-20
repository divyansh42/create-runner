FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2

ENV HELM_LATEST_VERSION="v3.5.0"
ENV OC_VERSION="4.6.12"
ENV OC_FILENAME="openshift-client-linux.tar.gz"

COPY ./entrypoint.sh /entrypoint.sh

RUN microdnf install -y wget git bash tar gzip
RUN wget -q https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/${OC_FILENAME} && \
        tar zxfv ${OC_FILENAME} --exclude='README.md' -C /usr/local/bin/ && \
        rm $OC_FILENAME && \
        chmod +x /usr/local/bin/oc \
    && mv linux-amd64/helm /usr/local/bin \
    && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && chmod +x entrypoint.sh
    
ENTRYPOINT [ "/entrypoint.sh" ]