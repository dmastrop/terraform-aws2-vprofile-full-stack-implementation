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
bastion-host.tf

backend-services.tf and beanstalk-env.tf form the core of the infra deployment: RDS, elasticache, rabbitmq backend with elastic beanstalk ALB frontend with tomcat server on private address space. Deploy the .war vprofile app onto the tomcat servers, and also intialize the mysql backend db with a bastion host method.

The bastion host method uses local and remote provisioners with a script to provision the mysql RDS server for the project

Once the infra is up and running, for now manually deploy the vprofile.war file. To do this manually rebuild the artifact.war file with maven (mvn install).  To do this must configure the application.properties file with the proper endponts for the RDS, RabbitMQ and Elasticache servers, as well as with the passwords and the proper ports.   The terraform has provisioned the servers with the same passwords as configured in the vars.tf file. In reality we would not commit such code but rather would use terraform.tfvars which is in the .gitignore file and will not be pushed to the repository.  But this is simply a test deployment of a full stack java application.  

The new .war file that is built has the proper passwords and endpoints built into it in application.properties, so this java app installed and pushed to the tomcat servers in the Elastic Beanstalk deployment will be able to establish socket connections to all of the backend servers and function properly.

Note: the vprofile app does not work with mysql 8.0 so had to use 5.7.44 which is still in extended release but is EOL as of Feb/March 2024

For now, the only manual part that has not been automated is the building of the artifact and the deployment of the artifact to the Elastic Beanstalk environment, but this can easily be automated with a github actions or jenkinsfile pipeline or on AWS itself with AWS Build and Code and Artifact/Deploy and Pipeline as in previous projects.

A similar project will be done with GitOps with similar terraform IaaS but workflow to docker build and publish and to EKS rather than to Elastic Beanstalk.  Containers are much more easy and clean to deploy than EC2 server instances.  The docker container deployment can be orchestrated via K8s if required with the k8s cluster being setup with kops or kubeadm as in previous projects. There are many solutins to the CI/CD deployment paradigm....



