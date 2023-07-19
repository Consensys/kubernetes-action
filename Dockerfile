FROM alpine:latest
ARG KUBECTL_VERSION="1.27.1"
RUN apk add --no-cache py-pip curl && \
    pip install --no-cache-dir awscli && \
    curl -L -o /usr/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2023-04-19/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
