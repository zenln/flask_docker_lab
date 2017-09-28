#!/usr/bin/env bash
#set -x
if [ -f ./ecr.secret ]; then
  . ./ecr.secret
fi

docker login -u ${ECR_USER} -p ${ECR_PASS} ${ECR_URL}
docker tag flask_docker_lab:latest ${ECR_DNS}/flask_docker_lab:latest
docker push ${ECR_DNS}/flask_docker_lab_ecr:latest
