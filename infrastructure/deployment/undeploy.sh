#!/bin/sh -e

#Usage: [create|update] TAG
DOCKER_COMPOSE='../../docker-compose.yaml'
if [ ! -f ${DOCKER_COMPOSE} ]; then
  echo "Error, cant find file ${DOCKER_COMPOSE}"
  exit 1
fi

TFVARS='../terraform-ecs/terraform.tfvars'
if [ ! -f ${TFVARS} ]; then
  echo "Error, cant find file ${TFVARS}"
  exit 2
fi

# Delete service
SERVICE_TASK=delete
# The AWS region we're working in
REGION=`grep region ${TFVARS} | awk -F'=' '{print$2}' | sed 's/\"//g' | sed s/' '//g`
ENVIRONMENT=`grep environment ${TFVARS} | awk -F'=' '{print$2}' | sed 's/\"//g' | sed s/' '//g`
PROJECT=`grep project ${TFVARS} | awk -F'=' '{print$2}' | sed 's/\"//g' | sed s/' '//g`
# The image name for the docker container
IMAGE=`grep container_name ${DOCKER_COMPOSE} | awk -F':' '{print$2}' | sed s/' '//g`

echo "${SERVICE_TASK}: service with AWS"
echo "Setting desired-count to 0"
aws ecs update-service --cluster ${PROJECT}_${ENVIRONMENT}_ecs_cluster --service ${IMAGE}_svc --desired-count 0 --region $REGION > SERVICEDEF.out
echo "Deleting service"
aws ecs delete-service --cluster ${PROJECT}_${ENVIRONMENT}_ecs_cluster --service ${IMAGE}_svc --region $REGION > DELETED_SERVICE.out
echo "done"
