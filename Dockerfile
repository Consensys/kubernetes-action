FROM alpine:latest
ARG KUBECTL_VERSION="1.27.1"
RUN apk add py-pip curl
RUN pip install awscli
RUN curl -L -o /usr/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2023-04-19/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
