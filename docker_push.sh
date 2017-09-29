#!/usr/bin/env bash
# We want this script to exit if we get any errors
set -e
# This script pushes the built docker image to the repository

# We should have secrets file created by create_ecr_secrets.sh, encoded
# in the dev environment and decoded in the travis environment

# Import the AWS ECR variables
. ./ecr.secrets

# Log into the AWS ECR repository
docker login -u ${ECR_USER} -p ${ECR_PASS} ${ECR_URL}

# Push this version as :latest
docker push ${ECR_DNS}/flask_docker_lab:latest

# Tag the image we built with the tag sent from github
docker tag flask_docker_lab:latest ${ECR_DNS}/flask_docker_lab_repository:${TAVIS_TAG}

# Now push the docker image again AWS ECR repository with version tag
docker push ${ECR_DNS}/flask_docker_lab:${TRAVIS_TAG}
