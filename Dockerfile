FROM node:18-bullseye
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION="us-west-2"

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install


RUN npm install --location=global aws-cdk
RUN apt-get update -y
RUN apt-get install -y python3 python3-pip

WORKDIR /opt
COPY . .

RUN python3 -m pip install -e ".[dev,deploy,test]"
RUN python3 -m pip install --upgrade pip

CMD '/opt/entrypoint.sh'