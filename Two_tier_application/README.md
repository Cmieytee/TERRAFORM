#  The project focuses on deploying a 2-tier application on AWS with terraform, automating infrastructure provisioning and management, enhancing scalability and maintainability.

STEP 1 - PROVIDER FILE

The provider.tf file in Terraform serves as the directive for specifying the chosen cloud provider, such as AWS, Azure, Google Cloud, etc., to be utilized for infrastructure deployment. Think of it as selecting the right toolbox for a specific task.
Within this file, you define the particulars necessary for Terraform to establish a connection with the designated cloud provider, including credentials and configuration settings. Essentially, it entails furnishing Terraform with the necessary access keys to proficiently manage and orchestrate resources within that cloud environment on your behalf.

STEP 2 - NETWORK RESOURCE 

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
