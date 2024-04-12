# terraform-aws2-vprofile-full-stack-implementation
Project16: Full stack implementation of vprofile app using terraform IaaC for network infra automation and some of the stack implementation on AWS2

backend-services.tf
backend.tf
beanstalk-app.tf
beanstalk-env.tf
keys_aws.tf
providers.tf
secgrp.tf
var.tf
vpc.tf

backend-services.tf and beanstalk-env.tf form the core of the infra deployment: RDS, elasticache, rabbitmq backend with elastic beanstalk ALB frontend with tomcat server on private address space. Deploy the .war vprofile app onto the tomcat servers, and also intialize the mysql backend db with a bastion host method.

