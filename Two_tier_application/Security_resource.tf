
# Security Group for Ec2 instance

resource "aws_security_group" "two_tier_EC2_SG" {

    name = "two_tier_EC2_SG"
    description = "Allow traffic from VPC"
    depends_on = [
        aws_vpc.two_tier_app_vpc
    ]
    vpc_id = aws_vpc.two_tier_app_vpc.id

    ingress {

        description = "Allowing all traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
    }


    ingress {

        description = "Allowing HTTP traffic"

        from_port = 80
        to_port = 80
        protocol = "tcp"

        cidr_blocks = ["0.0.0.0/0"]


    }


    ingress {

        description = "Allowing SSH access"

        from_port = 22
        to_port = 22
        protocol = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {

        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]


    tags = {

         Name = "two_tier_EC2_SG" 

        }

    }
        
    
}


# Security group for load Balancer

resource "aws_security_group" "two_tier_alb_SG" {

    name = "two_tier_alb_SG"
    description = "Allow traffic from the VPC"

    depends_on = [
        aws_vpc.two_tier_app_vpc
    ]
    vpc_id = aws_vpc.two_tier_app_vpc.id

    ingress {


        description = "Allowing all traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {

        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        tags = {
            Name = "two_tier_alb_SG"
        }
    }

    }


# Security Group for Database Tier 
resource "aws_security_group" "two_tier_db_SG" {


    name = "two_tier_db_SG"
    description = "Allow traffic from the VPC"

    depends_on = [
        aws_vpc.two_tier_app_vpc
    ]
    vpc_id = aws_vpc.two_tier_app_vpc.id


    ingress {
        description = "Allowing MySQL traffic"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.two_tier_EC2_SG.id]
        cidr_blocks =  ["0.0.0.0/0"]

    }

    ingress {

        description = "Allowing SSH traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.two_tier_EC2_SG.id]
        cidr_blocks =  ["10.0.0.0/16"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks =  ["0.0.0.0/0"]

    }


}


