# VPC 

resource "aws_vpc" "two_tier_app_vpc" {

    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default" 
    tags = {
        Name = "two_tier_app_vpc"
    }

}

# public subnets

resource "aws_subnet" "public_two_tier_subnet1" {
    vpc_id = aws_vpc.two_tier_app_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"

    availability_zone = "us-east-1a"

    tags = {
        Name = "public_two_tier_subnet1"
    }
}

resource "aws_subnet" "public_two_tier_subnet2" {
    vpc_id = aws_vpc.two_tier_app_vpc.id
    cidr_block = "10.0.0.0/18"
    map_public_ip_on_launch = "true"

    availability_zone = "us-east-1b"

    tags = {
        Name = "public_two_tier_subnet2"
    }
}

# private subnets

resource "aws_subnet" "private_two_tier_subnet1" {
    vpc_id = aws_vpc.two_tier_app_vpc.id
    cidr_block = "10.0.128.0/18"
    map_public_ip_on_launch = "false"

    availability_zone = "us-east-1a"

    tags = {
        Name = "private_two_tier_subnet1"
    }
}

resource "aws_subnet" "private_two_tier_subnet2" {
    vpc_id = aws_vpc.two_tier_app_vpc.id
    cidr_block = "10.0.192.0/18"
    map_public_ip_on_launch = "false"

    availability_zone = "us-east-1b"

    tags = {
        Name = "private_two_tier_subnet2"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "two_tier_GW" {

    vpc_id = aws_vpc.two_tier_app_vpc.id

    tags = {


        Name = "two_tier_GW"
    }
}

# Route table 
resource "aws_route_table" "two_tier_RT" {

    tags = {
        Name = "two_tier_RT"
    }
    vpc_id = aws_vpc.two_tier_app_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.two_tier_GW.id

    }
}

# Route table association

resource "aws_route_table_association" "two_tier_RT-1" {

    subnet_id = aws_subnet.public_two_tier_subnet1

    route_table_id = aws_route_table.two_tier_RT.id
}

resource "aws_route_table_association" "two_tier_RT-2" {

    subnet_id = aws_subnet.public_two_tier_subnet2

    route_table_id = aws_route_table.two_tier_RT.id
}


# Load Balancer

resource "aws_lb" "two_tier_LB" {
    name = "two_tier_LB_application"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.two_tier_alb_SG.id]
    subnets = [aws_subnet.public_two_tier_subnet1.id, aws_subnet.public_two_tier_subnet2.id]

    enable_deletion_protection = true

    tags = {
        Environment = "Two_tier_LB"
    }

   
}

# Target group

resource "aws_lb_target_group" "two_tier_TG" {

    name = "two-tier-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.two_tier_app_vpc.id

}


# Listener

resource "aws_lb_listener" "two_tier_listener" {

    load_balancer_arn = aws_lb.two_tier_LB.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.two_tier_TG.arn
    }


}

# Target group for Database subnet

resource "aws_lb_target_group" "two_tier_database_TG" {

    name = "two-tier-database-tg"
    depends_on = [aws_vpc.two_tier_app_vpc]
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.two_tier_app_vpc.id

}

# Target group attachment

resource "aws_lb_target_group_attachment" "two_tier_TG_attach1" {

    target_group_arn = aws_lb_target_group.two_tier_TG

    target_id = aws_instance.two_tier_web-server-1.id

    port = 80
}

resource "aws_lb_target_group_attachment" "two_tier_TG_attach2" {

    target_group_arn = aws_lb_target_group.two_tier_TG

    target_id = aws_instance.two_tier_web-server-2.id
    
    port = 80
}

# Subnet group resource

resource "aws_db_subnet_group" "two_tier_DB_subnet" {

    name = "two_tier_db_subnet"
    subnet_ids = [aws_subnet.private_two_tier_subnet1.id, aws_subnet.private_two_tier_subnet2.id]
}

