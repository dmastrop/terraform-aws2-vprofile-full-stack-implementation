resource "aws_security_group" "vprofile-project16-bean-elb-sg" {
# first security group is for the ALB for beanstalk
    name = "vprofile-project16-bean-elb-sg"
    description = "Security group for bean-elb"
    vpc_id = module.vpc.vpc_id
    # the vpc is a module.  The module returns a lot of outptus
    # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest/examples/complete?tab=outputs
    # default_vpc_id is the output that we  need to attach to this security group if default vpc
    # also vpc_id is vpc_id for non-default vpc's. We can use vpc_id
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        # all output traffic from anywhere
    }

    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
        # all port 80 traffic from anywhere since this is a loadbalancer
    }
}


resource "aws_security_group" "vprofile-project16-bastion-sg" {
    name = "vprofile-project16-bastion-sg"
    description = "Security group for bastion host ec2 instance"
    vpc_id = module.vpc.vpc_id

  egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        # all output traffic from anywhere
    }

    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = [var.my_ip]
        # all port 80 traffic from anywhere since this is a loadbalancer
    }
}

resource "aws_security_group" "vprofile-project16-prod-beanstalk-sg" {
    name = "vprofile-project16-prod-beanstalk-sg"
    description = "Security group for beanstalk instances"
    vpc_id = module.vpc.vpc_id
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        # all output traffic from anywhere
    }

    # these beanstalk instances will only be on private network so only accessible by the bastion host
    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        security_groups = [aws_security_group.vprofile-project16-bastion-sg.id]
        # SSH only from the bastion host
    }
}

# backend services security group
resource "aws_security_group" "vprofile-project16-backend-sg" {
    name = "vprofile-project16-backend-sg"
    description = "Security group for RDS, active MQ, and elastic cache"
    vpc_id = module.vpc.vpc_id
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = [aws_security_group.vprofile-project16-prod-beanstalk-sg.id]
        # allow traffic from the beanstalk instances to all of the backend server instances on all protocols
    }
}


# need to allow backend servers to connect to each other as well
# this resource below will add a rule to the backend security group above vprofile-project16-backend-sg
resource "aws_security_group_rule" "sec_group_backend_allow_itself" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_group_id = aws_security_group.vprofile-project16-backend-sg.id
    # this is the security group that want to add this rule to
    source_security_group_id = aws_security_group.vprofile-project16-backend-sg.id
    # this is the source of resources to apply this additional rule to
    # this allows all connections between all servers in this security group.
}