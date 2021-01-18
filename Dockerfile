FROM registry.access.redhat.com/ubi8/ubi-minimal:8.2

ENV OPENSHIFT_VERSION=4.6
ENV KNATIVE_CLIENT_VERSION=v0.17.4

RUN microdnf install -y curl \
    && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]