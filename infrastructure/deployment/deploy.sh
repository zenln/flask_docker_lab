#!/bin/sh -e

#Usage: deploy.sh [create|update] TAG
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

if [ ! $1 ] || [ ! $2 ]; then
  echo "Error, Usage: deploy.sh [create|update] TAG"
  exit 3
fi

# This is the tag for the image name (i.e. latest, v1.0)
TAG=$2
# Create or update service
SERVICE_TASK=$1
# This is the port that the docker image listens on
PORT=5000
# This is the memory allocated to the docker image
MEM=128
# The AWS region we're working in
REGION=`grep region ${TFVARS} | awk -F'=' '{print$2}' | sed 's/\"//g' | sed s/' '//g`
ENVIRONMENT=`grep environment ${TFVARS} | awk -F'=' '{print$2}' | sed 's/\"//g' | sed s/' '//g`
PROJECT=`grep project ${TFVARS} | awk -F'=' '{print$2}' | sed 's/\"//g' | sed s/' '//g`
# The image name for the docker container
IMAGE=`grep container_name ${DOCKER_COMPOSE} | awk -F':' '{print$2}' | sed s/' '//g`
# The AWS account ID that we are working in
ACCOUNT=`aws sts get-caller-identity --output text --query 'Account'`
# The ELB Target Group arn
TGT_GRP_NAME=`echo ${PROJECT}-${ENVIRONMENT}-alb-tgt-grp | sed s/_/-/g `
TGT_GRP_ARN=`aws elbv2 describe-target-groups --region ${REGION} \
  | grep TargetGroupArn | grep ${TGT_GRP_NAME} | cut -d ':' -f 2- \
  | sed s/,// | sed 's/\"//g' | sed s/' '//g`
# register task-definition
echo "Creating task definition file ./TASKDEF.out"
cat td.template | sed s/@TAG@/${TAG}/ | sed s/@PORT@/${PORT}/ \
  | sed s/@MEM@/${MEM}/ | sed s/@IMAGE@/${IMAGE}/g | sed s/@ACCOUNT@/${ACCOUNT}/\
  | sed s/@REGION@/${REGION}/ | sed s/@ENVIRONMENT@/${ENVIRONMENT}/ > TASKDEF.out

echo "Registering task definition w/ AWS"
aws ecs register-task-definition --region ${REGION} \
  --cli-input-json file://TASKDEF.out > REGISTERED_TASKDEF.out

# Requires the jason parser "jq"
TASKDEFINITION_ARN=$( < REGISTERED_TASKDEF.out jq .taskDefinition.taskDefinitionArn )
TASKDEFINITION_ARN=`echo ${TASKDEFINITION_ARN} | sed 's/\"//g'`
echo "New Task Definition registered: ${TASKDEFINITION_ARN}"

# create or update service
echo "Creating '${SERVICE_TASK}' service definition file ./SERVICEDEF.out"
cat service-${SERVICE_TASK}.json | sed s/@TAG@/${TAG}/ | sed s/@PORT@/${PORT}/ \
  | sed s/@MEM@/${MEM}/ | sed s/@IMAGE@/${IMAGE}/g | sed s/@ACCOUNT@/${ACCOUNT}/ \
  | sed s/@REGION@/${REGION}/ | sed s/@ENVIRONMENT@/${ENVIRONMENT}/ \
  | sed s/@PROJECT@/${PROJECT}/ | sed s#@TGT_GROUP_ARN@#${TGT_GRP_ARN}# \
  | sed s#@TASKDEFINITION_ARN@#${TASKDEFINITION_ARN}# > SERVICEDEF.out

echo "${SERVICE_TASK}: service with AWS"
aws ecs ${SERVICE_TASK}-service --region ${REGION} --cli-input-json file://SERVICEDEF.out > REGISTERED_SERVICE.out
echo "done"
