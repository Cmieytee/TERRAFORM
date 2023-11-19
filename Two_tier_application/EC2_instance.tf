# First WEBserver
resource "aws_instance" "two_tier_web-server-1" {

    ami = "ami-01bc990364452ab3e"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.two_tier_EC2_SG.id]
    subnet_id = [aws_subnet.public_two_tier_subnet1.id]
    key_name  = "two_tier_key"

    user_data = <<-EOF

#!/bin/bash
sudo yum update -y

sudo amazon-linux-extras install nginx1 -y

sudo systemctl enable nginx

sudo systemctl start nginx

EOF

}


# second WEBserver
resource "aws_instance" "two_tier_web-server-2" {

    ami = "ami-01bc990364452ab3e"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.two_tier_EC2_SG.id]
    subnet_id = [aws_subnet.public_two_tier_subnet2.id]
    key_name  = "two_tier_key"

    user_data = <<-EOF

#!/bin/bash
sudo yum update -y

sudo amazon-linux-extras install nginx1 -y

sudo systemctl enable nginx

sudo systemctl start nginx

EOF

}


# Configuring the EIP for the first EC2 instances

resource "aws_eip" "two_tier_web-server-1-eip" {

    vpc = true 

    instance = aws_instance.two_tier_web-server-1.id

    depends_on =[aws_internet_gateway.two_tier_GW]
}

# Configuring the EIP for the second EC2 instances

resource "aws_eip" "two_tier_web-server-2-eip" {

    vpc = true 

    instance = aws_instance.two_tier_web-server-2.id

    depends_on =[aws_internet_gateway.two_tier_GW]
}

