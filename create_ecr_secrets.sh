#!/usr/bin/env bash
set -e
# This script uses the aws cli to get the ecr login information
# and stores it in the ecr.secrets file locally

OUTFILE=ecr.secrets
# TODO: make this dynamic...
AWS_REGION='us-west-2'

echo "Creating ecs.secret file"
# This is the command that gives us docker login command w/ credentials
# Note, must be authenticated to aws for this command
ECR_CMD="aws ecr get-login --no-include-email --region ${AWS_REGION}"
# Run ecr command, then extract the user name of the repo, store in secrets file
echo "ECR_USER=`${ECR_CMD} | awk '{print$4}'`" > ${OUTFILE}
# Run ecr command, then extract the password for the repo, store in secrets file
echo "ECR_PASS=`${ECR_CMD} | awk '{print$6}'`" >> ${OUTFILE}
# Run ecr command, then extract the url of the repo, store in secrets file
echo "ECR_URL=`${ECR_CMD}  | awk '{print$7}'`" >> ${OUTFILE}
# Run ecr command, then extract the dns name for the repo, store in secrets file
echo "ECR_DNS=`${ECR_CMD}  | awk '{print$7}' | sed s/'https:\/\/'//`" >> ${OUTFILE}


echo "Encrypting the ${OUTFILE} file"
# Now, encrypt the ecs.secrets file into ecs.secretes.enc and add decoding
# instructions to the .travis.yml file.
# Note, must be logged into travis for this step
travis encrypt-file ${OUTFILE} --add -f

echo "Successfully created and encrypted ${OUTFILE}"
