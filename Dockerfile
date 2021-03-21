FROM ubuntu:18.04

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
        python3-pip \
        unzip \
        wget \
        gcc \
        curl \
        awscli;

RUN wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip; \
    unzip terraform_0.13.0_linux_amd64.zip; \
    mv terraform /usr/local/bin/; \
    terraform --version

ENV PATH=~/.local/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
