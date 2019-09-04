FROM bash:latest

ARG DEVOPS_UID=1000

RUN addgroup -S devops && adduser -u ${DEVOPS_UID} -S devops -G devops && mkdir -p /home/devops \
    && apk add --no-cache curl wget jq git python docker openssh

RUN K8S_VER=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt` \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && echo "source /home/devops/google-cloud-sdk/path.bash.inc" >> /home/devops/.bash_profile

USER devops
ENV HOME=/home/devops
WORKDIR /home/devops

RUN URL=https://dl.google.com/dl/cloudsdk/channels/rapid/install_google_cloud_sdk.bash \
    && CLOUDSDK_INSTALL_DIR=/home/devops \
    && curl -sSL https://dl.google.com/dl/cloudsdk/channels/rapid/install_google_cloud_sdk.bash | sed 's|/bin/bash|/usr/local/bin/bash|g' | bash

CMD ["/usr/local/bin/bash", "-l"]
