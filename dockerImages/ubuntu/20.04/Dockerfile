FROM ubuntu:20.04

# Input args
ARG kubectl_version="installing the latest"
ARG terraform_version="0.13.3"
ARG terragrunt_version="0.26.7"
ARG aws_cli_version="installing the latest"
ARG saml2aws_version="2.27.1"
ARG kind_version="v0.7.0"

# Envars
ENV TERRAFORM_VERSION=$terraform_version
ENV TERRAGRUNT_VERSION=$terragrunt_version
ENV SAML2AWS_VERSION=$saml2aws_version
ENV KIND_VERSION=$kind_version

# Update the base image and install base items
RUN apt-get update
RUN apt-get install vim wget curl ssh

# Install kubectl
RUN apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Install Terraform
WORKDIR /tmp
RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip
RUN unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip
RUN cp /tmp/terraform /usr/local/bin/terraform

# Install Terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_amd64
RUN chmod 755 ./terragrunt_linux_amd64
RUN cp terragrunt_linux_amd64 /usr/local/bin/terragrunt

# Install saml2aws
RUN wget https://github.com/Versent/saml2aws/releases/download/v$SAML2AWS_VERSION/saml2aws_$SAML2AWS_VERSION_linux_amd64.tar.gz
RUN tar -zxvf saml2aws_$SAML2AWS_VERSION_linux_amd64.tar.gz
RUN cp saml2aws /usr/local/bin/saml2aws

# Install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Install KinD
RUN curl https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64 -o /usr/local/bin/kind -L
RUN chmod +x /usr/local/bin/kind