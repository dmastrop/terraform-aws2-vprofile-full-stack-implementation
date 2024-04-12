# Elastic Beanstalk app

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application

resource "aws_elastic_beanstalk_application" "vprofile-project16-elastic-beanstalk-prod-application" {
  name        = "vprofile-project16-elastic-beanstalk-prod-application"
  description = "vprofile-project16-elastic-beanstalk-app-description"
}