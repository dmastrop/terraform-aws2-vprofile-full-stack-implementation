# Elastic Beanstalk env

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment
# Option Settings
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment#option-settings
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html

resource "aws_elastic_beanstalk_environment" "vprofile-project16-elastic-beanstalk-prod-env" {
  name        = "vprofile-project16-elastic-beanstalk-prod-env"
  application = aws_elastic_beanstalk_application.vprofile-project16-elastic-beanstalk-prod-application

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html
  # tomcat deployment::
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.java
  # use the corretto 11 version: 64bit Amazon Linux 2023 v5.1.5 running Tomcat 9 Corretto 11
  #solution_stack_name = "64bit Amazon Linux 2 v4.1.1 running Tomcat 8.5 Correto 11"
  solution_stack_name = "64bit Amazon Linux 2023 v5.1.5 running Tomcat 9 Corretto 11"
  # the cname_prefix is the prepend to the URL
  cname_prefix = "vprofile-project16-bean-prod-domain"


  # the next blocks are a series of settings based upon the Option settings:
  # Option Settings
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment#option-settings
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html

  setting {
    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-ec2vpc
    name      = "VPCId"
    namespace = "aws:ec2:vpc"
    value     = module.vpc.vpc_id
  }

  setting {
    namespace = "aws:autoscaling:launchocnfiguration"
    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalinglaunchconfiguration
    name  = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:ec2:vpc"
    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-ec2vpc
    name  = "AssociatePublicAddress"
    value = "false"
  }

  setting {
    # private subnet space for tomcat instances
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    # The IDs of the Auto Scaling group subnet or subnets. If you have multiple subnets, specify the value as a single comma-separated string of subnet ID
    value = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
    # value is a string not a list, but join will convert the list to a string so that we can set the value as such.
    # https://developer.hashicorp.com/terraform/language/functions/join
  }

  setting {
    # loadbalancer will be in public space
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    # The IDs of the subnet or subnets for the elastic load balancer. If you have multiple subnets, specify the value as a single comma-separated string of subnet IDs
    value = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalinglaunchconfiguration
    # The instance type that's used to run your application in an Elastic Beanstalk environment.
    name  = "InstanceType"
    value = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.vprofile-keypair-terraform-project16.key_name
    # keys_aws.tf file
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "8"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "environment"
    value     = "vprofile-project16-elastic-beanstalk-prod-env"
  }

  setting {
    namespace = "aws:elasticbeanstalk:applicaton:environment"
    name      = "LOGGING_APPENDER"
    value     = "GRAYLOG"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
    #value = "basic"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  setting {
    # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-environmentprocess
    # aws:elasticbeanstalk:environment:process:default
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:commmand"
    name      = "BatchSizeType"
    value     = "Fixed"
  }

  setting {
    namespace = "aws:elasticbeanstalk:commmand"
    name      = "BatchSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }

  setting {
    # this is the security group for tomcat instances on private subnet
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.vprofile-project16-prod-beanstalk-sg.id
  }

  setting {
    # this is the security group for the applicaton loadbalancer frontend on public subnet
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.vprofile-project16-bean-elb-sg.id
  }

  # sometimes the security groups are not created before beanstalk environment
  # this is a bug that can occur via timing. Most of the time it will figure this out but best to create dependency
  # use depends_on 
  depends_on = [aws_security_group.vprofile-project16-bean-elb-sg, aws_security_group.vprofile-project16-backend-sg, aws_security_group.vprofile-project16-prod-beanstalk-sg, aws_security_group.vprofile-project16-bastion-sg]
}


