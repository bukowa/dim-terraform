FROM alpine

RUN apk update && \
    apk upgrade && \
    apk --no-cache add gnupg curl unzip

WORKDIR /usr/local/bin

RUN gpg --batch --keyserver keys.gnupg.net --recv-key=\
    "91A6 E7F8 5D05 C656 30BE F189 5185 2D87 348F FC4C"

ENV TERRAFORM_VER=0.12.29

RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip && \
    curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_SHA256SUMS && \
    curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_SHA256SUMS.sig

RUN gpg --batch \
    --verify terraform_${TERRAFORM_VER}_SHA256SUMS.sig terraform_${TERRAFORM_VER}_SHA256SUMS

RUN cat terraform_${TERRAFORM_VER}_SHA256SUMS|grep terraform_${TERRAFORM_VER}_linux_amd64.zip|\
    sha256sum -c -

RUN unzip terraform_${TERRAFORM_VER}_linux_amd64.zip
RUN ls -al

WORKDIR /app

ENTRYPOINT ["terraform"]
