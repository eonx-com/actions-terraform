FROM ubuntu:18.04

RUN apt-get update -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3-pip \
        python3-setuptools \
        unzip \
        wget \
        gnupg \
        build-essential \
        libssl-dev \
        libffi-dev \
        cargo \
        git \
        gcc \
        curl \
        zip \
        awscli;

RUN pip3 install -upgrade pip; \
    pip3 install setuptools setuptools-rust pgpy;

RUN wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip; \
    unzip terraform_0.13.0_linux_amd64.zip; \
    mv terraform /usr/local/bin/; \
    terraform --version

ENV PATH=~/.local/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
