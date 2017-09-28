#!/usr/bin/env bash
# We want this script to exit if we get any errors
set -o
# This script pushes the built docker image to the repository

# We should have secrets file created by create_ecr_secrets.sh, encoded
# in the dev environment and decoded in the travis environment

# Import the AWS ECR variables
. ./ecr.secret

# Log into the AWS ECR repository
docker login -u ${ECR_USER} -p ${ECR_PASS} ${ECR_URL}
# Tag the image we built
# TODO: get a tagged version number from github, instead of "latest"
docker tag flask_docker_lab:latest ${ECR_DNS}/flask_docker_lab:latest
# Now push the docker image to AWS ECR repository
docker push ${ECR_DNS}/flask_docker_lab_ecr:latest
