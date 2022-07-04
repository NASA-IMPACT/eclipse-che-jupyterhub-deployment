FROM node:18-bullseye AS root
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION="us-west-2"

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# CDK Stuff
RUN npm install --location=global aws-cdk
RUN apt-get update -y
RUN apt-get install -y python3 python3-pip

# Kubernetes Stuff
RUN apt-get install -y apt-transport-https ca-certificates curl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl

WORKDIR /opt

COPY setup.py .
COPY README.md .

RUN python3 -m pip install -e ".[dev,deploy,test]"

FROM root

COPY . .

CMD '/opt/entrypoint.sh'
