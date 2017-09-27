#### flask_docker_lab

This is a basic Flask web application that will be deployed to AWS ECS using docker

1. github account setup
  - Create a new github account (if you dont already have one)
  - create new repository flask_docker_lab (public/no readme)
2. travis-ci account setup
  - Create a new travis-ci.org account if you dont already have one
  - link travis-ci to github
  - add flask_docker_lab project
3. AWS account setup
  - Create a new AWS free tier account if you don't already have one
4. Setup developer workstation
  - Open AWS Console
  - Create EC2 Admin role
  - Launch AWS EC2 Developer AMI ami-<TBD> w/ admin role
  - Connect to AWS Developer Desktop Browser: http://<public_ip> pass: dockerlab
    or vnc to <public_ip>:5901 pass:dockerlab (easier)
5. Download the code and make it your own
  - git clone http://github.com/peterb154/flask_docker_lab
  - cd flask_docker_lab
  - rm -r .git
  - git init
  - git add .
  - git remote add origin https://github.com/${github_username}/flask_docker_lab.git
  - git push origin master (NOTE: if .travis.yml present, will cause a travis build...)
6. Check out the application locally
  - docker-compose up
  - Browser: http://localhost:5000
  - change something
  - validate change in browser
6. Configure AWS Infrastructure using terraform
  - cd infrastructure
  - TODO: create a terraform script
  - terraform init
  - terraform plan
  - terraform apply
7. Build the .travis.yml
  - cp travis.yml.example .travis.ci
  - ECR_CMD='aws ecr get-login --no-include-email --region us-west-2'
  - travis env set ECR_DNS=`${ECR_CMD} | awk '{print$4}' | sed s/'https://'//`
  - travis env set ECR_USER=`${ECR_CMD} | awk '{print$4}'`
  - travis env set ECR_URL=`${ECR_CMD} | awk '{print$7}'`
  - travis encrypt ECR_USER=`${ECR_CMD} | awk '{print$6}'` -add
  -
