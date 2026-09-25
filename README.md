This a clone project of one of the previous projects I participated in. A lot has been altered and does not match the original project 
Project Name - ANDREWS-AWS-LEGACY-MIGRATION

#                               Business Problem
 - The company was projecting that in about 6 months, production was going to increase its production (the new productuion building was still under construction). We agreed that we needed to move our web application from the locally hosted server because the application supportedd recipes, customer inquiries, and marketing pages. And also online orders were expected to increase from retailers and customers. Migrating the web application from the local host environment to AWS was going to create a secure, repeatable, recoverable cloud architecture using Terraform


#                   Current-State Architecture to Target Architecture:
 We used Terraform for Infrastructure as Code. VPC, subnet, routes and Internet Gateway for networking. For computing we used EC2. As out operating system, we used Ubuntu Linux. We used Apache as our web server. Wordpress and PHP to host the web application. As our database, we used MySQL/RDS. S3 for storage. For securtity we used Security Groups and practiced least privilege with IAM. And CloudWatch was used for monitoring the overall health of the resources provisioned.


#                                  Networking
We provisoned 4 subnets, 2 public and 2 private. The public subnets were for the Application Load Balancer (inbound traffic) and NAT Gateway (outbounf traffic) and the private subnets were fo the EC2 (host server) and RDS (database). And each of them was kept at diffferent availabilty ones. Then we provisoned public route tables and associated them with the public subnets.

#                                  Security Groups
We provisoned Security Groups to implement layered security. The ALB securtiy group to allow port 80 (HTTP) and 443 (HTTPS). The Application Security Group to only alllow port 80 (HTTP) from the ALB Security Group. And te Database Security Group to only allow port 3306 from the Application Security Group

Technologies-
Migration Objectives - We