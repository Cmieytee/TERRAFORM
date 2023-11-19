#  The project focuses on deploying a 2-tier application on AWS with terraform, automating infrastructure provisioning and management, enhancing scalability and maintainability.


![image](https://github.com/Cmieytee/TERRAFORM/assets/129941983/fa95f71e-9f80-4852-89d9-946459b8f353)


# STEP 1 - PROVIDER FILE

The provider.tf file in Terraform serves as the directive for specifying the chosen cloud provider, such as AWS, Azure, Google Cloud, etc., to be utilized for infrastructure deployment. Think of it as selecting the right toolbox for a specific task.
Within this file, you define the particulars necessary for Terraform to establish a connection with the designated cloud provider, including credentials and configuration settings. Essentially, it entails furnishing Terraform with the necessary access keys to proficiently manage and orchestrate resources within that cloud environment on your behalf.

# STEP 2 - NETWORK RESOURCE 

## VPC Creation (aws_vpc):

Establishes a Virtual Private Cloud (VPC) with the specified CIDR block (10.0.0.0/16).
Adds tags for identification.

## Public Subnet Creation (aws_subnet):

Generates two public subnets within the VPC.
Enables public IP mapping, allowing instances to possess public IP addresses.
Associates each subnet with an availability zone in the ap-southeast-1 region.
Includes tags for identification.

## Private Subnet Creation (aws_subnet):

Creates two private subnets within the VPC.
Disables public IP mapping to prevent direct public internet access for instances.
Associates subnets with availability zones and adds identification tags.

## Internet Gateway Setup (aws_internet_gateway):
Establishes an internet gateway and links it to the VPC.
Enables resources within the VPC to connect to the internet and vice versa.

## Route Table Configuration (aws_route_table):

Creates a route table linked to the VPC.
Defines a default route (0.0.0.0/0) via the internet gateway.
Used by public subnets to route traffic to the internet.

## Association of Route Tables with Public Subnets (aws_route_table_association):

Associates the route table from the previous step with public subnets.
Ensures public subnet instances use the specified route table for internet-bound traffic.
#Load Balancer Setup (aws_lb):

Establishes an Application Load Balancer (ALB) with a name.
Specifies it as non-internal, accessible from the internet.
Attaches security groups to regulate inbound and outbound traffic.
Designates subnets for distributing incoming traffic across two public subnets.
Includes tags for identification.
## Target Group Creation (aws_lb_target_group):

Generates a target group for routing requests to backend instances.
Listens on port 80 using the HTTP protocol.
Associates with the VPC.
## Load Balancer Listener Establishment (aws_lb_listener):

Creates an ALB listener to handle incoming HTTP traffic on port 80.
Forwards incoming requests to the previously defined target group.
## Target Group for Database Subnet (aws_lb_target_group):

Establishes another target group for potential database instances.
Configured for future use, even though not currently attached in this configuration.
## EC2 Instance Attachment to Target Group (aws_lb_target_group_attachment):

Allows attachment of instances to the target group for the ALB.
Assumes the existence of two instances (aws_instance.two-tier-web-server-1 and aws_instance.two-tier-web-server-2) representing web servers in the architecture.
#Database Subnet Group Creation (aws_db_subnet_group):

Creates a database subnet group, specifying available private subnets for RDS instances.
Includes both private subnets established earlier.

# STEP 3 - SECURITY RESOURCE

## Ingress Rules (Inbound Traffic):

Permits all incoming traffic on all ports (from_port = "0", to_port = "0", protocol = "-1"). Note that this is generally not recommended for production and should be configured more restrictively.
Allows incoming traffic on port 80 (HTTP) from any source (cidr_blocks = ["0.0.0.0/0"]).
Allows incoming traffic on port 22 (SSH) from any source. It's essential to mention that this configuration is not recommended for production, and SSH access should ideally be confined to trusted IP addresses.
## Egress Rules (Outbound Traffic):

Enables all outgoing traffic to any destination (from_port = "0", to_port = "0", protocol = "-1").
Security Group for Load Balancer (aws_security_group.two-tier-alb-sg):

Defines a security group named "two-tier-alb-sg" associated with the same VPC as above (aws_vpc.two-tier-vpc.id). Dependencies are specified to ensure the VPC is created before this security group.

## Ingress Rules (Inbound Traffic):

Permits all incoming traffic on all ports from any source (from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"]). This configuration is generally not recommended for production as it exposes the load balancer to all traffic.
## Egress Rules (Outbound Traffic):

Allows all outgoing traffic to any destination (from_port = "0", to_port = "0", protocol = "-1").
## Security Group for Database Tier (aws_security_group.two-tier-db-sg):

Defines a security group named "two-tier-db-sg" associated with the same VPC as above (aws_vpc.two-tier-vpc.id).

## Ingress Rules (Inbound Traffic):

Permits incoming traffic on port 3306 (MySQL) from any source (from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"]). It's important to note that allowing MySQL traffic from anywhere is generally not recommended for production, and restrictions to trusted sources should be implemented.
Allows incoming traffic on port 22 (SSH) from a specific IP range within the VPC (from_port = 22, to_port = 22, protocol = "tcp", security_groups = [aws_security_group.two-tier-ec2-sg.id], cidr_blocks = ["10.0.0.0/16"]). This enhances security by restricting SSH access to a specific IP range within the VPC.

## Egress Rules (Outbound Traffic):

Enables all outgoing traffic to any destination (from_port = "0", to_port = "0", protocol = "-1").

