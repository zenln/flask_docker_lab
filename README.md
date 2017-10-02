#### flask_docker_lab

This is a basic Flask web application that will be deployed to AWS ECS using docker

1. github account setup
  - Create a new github account (if you dont already have one)
  - fork repository flask_docker_lab github.com/peterb154/flask_docker_lab
2. travis-ci account setup
  - Create a new travis-ci.org account if you don't already have one
  - link travis-ci to github
  - add your flask_docker_lab project
3. AWS account setup
  - Create a new AWS free tier account if you don't already have one
4. Setup developer workstation
  - Open AWS Console
  - Create EC2 Admin role
  - Launch AWS EC2 Developer AMI ami-<TBD> w/ admin role
  - Connect to AWS Developer Desktop Browser: http://<public_ip> pass: dockerlab
    or vnc to <public_ip>:5901 pass:dockerlab (easier)
5. Download the code and make it your own
  - git config --global user.email "you@example.com"
  - git config --global user.name "Your Name"
  - git clone http://github.com/${user}/flask_docker_lab
  - cd flask_docker_lab
6. Check out the application locally
  - docker-compose up
  - Browser: http://localhost:5000
  - change something
  - validate change in browser
6. Configure AWS Infrastructure using terraform
  - cd ./infrastructure
  - ssh-keygen
  - terraform init
  - terraform plan
  - terraform apply
7. Build the .travis.yml
  - cd ../
  - #TODO: create an example travis.yml
  - cp ./infrastructure/travis.yml.example .travis.ci
  - travis login # (enter github username and password)
  - ./create_ecr_secrets.sh # create a secrets file and encrypt it
8. Tag and push our code
  - git tag -a v1.0 -m "the first version of our application"
  - git push origin v1.0
  - Check travis-ci.org
  - Check AWS ECR repository
9. Induce an error
  - git tag -a v1.1 -m "the second version of our application"
  - edit ./app/config.py to induce a link error
      {'title':'Bad Link','url':'http://something.wrong'},
  - git add .
  - git commit -am "added a bad page"
  - git push --tags
  - Check out travis-ci.org - notice that the linktest failed
  - confirm in AWS ECR that new version was not deployed
10. Fix the error
  - git tag -a v1.2 -m "the third version of our application"
  - edit ./app/config.py to fix error
      {'title':'Good Link','url':'http://www.google.com'},
  - git add .
  - git commit -am "changed to a good page"
  - git push --tags
  - Check out travis-ci.org build process, confirm it succeeded
  - Check out AWS ECR, see new version 1.2 was created!
11. Deploy our application to production
  - ...
