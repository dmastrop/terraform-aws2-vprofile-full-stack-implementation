# RDS, ElastiCache and AmazonMQ deployment

# Need an RDS subnet
resource "aws_db_subnet_group" "vprofile-project16-rds-subgrp" {
  name       = "vprofile-project16-rds-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  tags = {
    Name = "Subnet group for RDS"
  }
}

resource "aws_elasticache_subnet_group" "vprofile-project16-elasticache-subgrp" {
  name       = "vprofile-project16-elasticache-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  tags = {
    Name = "Subnet group for Elasticache"
  }
}

resource "aws_db_instance" "vprofile-project16-rds-server" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
  # note 5.6.34 is no longer available. must use at least 8.0.32
  # this has to use db.t3.small
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version = "5.7.44"
  instance_class = "db.t3.micro"
  #engine_version    = "8.0.32"
  #instance_class    = "db.t3.small"
  #name                 = var.dbname
  db_name              = var.dbname
  username             = var.dbuser
  password             = var.dbpass
  #parameter_group_name = "default.mysql8.0"
  parameter_group_name = "default.mysql5.7"
  multi_az             = "false"
  # this is for high avaliablity only
  publicly_accessible = "false"
  # only beanstalk will need access privately
  skip_final_snapshot = true
  # this will cut costs
  db_subnet_group_name   = aws_db_subnet_group.vprofile-project16-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.vprofile-project16-backend-sg.id]
}


resource "aws_elasticache_cluster" "vprofile-project16-elasticache" {
  cluster_id      = "vprofile-project16-elasticache"
  engine          = "memcached"
  node_type       = "cache.t2.micro"
  num_cache_nodes = 1
  #parameter_group_name = "default.memcached1.5"
  parameter_group_name = "default.memcached1.6"
  # update this to current minimum version
  port               = 11211
  security_group_ids = [aws_security_group.vprofile-project16-backend-sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.vprofile-project16-elasticache-subgrp.name
}


resource "aws_mq_broker" "vprofile-project16-rmq" {
  broker_name = "vprofile-project16-rmq"
  engine_type = "ActiveMQ"
  #engine_version     = "5.15.0"
  # update this to proper minimum 5.15.16
  engine_version     = "5.15.16"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.vprofile-project16-backend-sg.id]
  #subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  # non-cluster
  subnet_ids = [module.vpc.private_subnets[0]]

  user {
    username = var.rmquser
    password = var.rmqpass
  }
}

