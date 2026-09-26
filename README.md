 # LEGACY MIGRATION PROJECT
 This project is a legacy migration and clone of a previous web application I contributed to. The core architecture and concepts remain the same but with a few adjustments. This was created for demonstration purposes.



## Business Problem
 The company was projecting that in about 6 months, production was going to increase. We agreed that we needed to move our web application from the locally hosted server because the application supported customer inquiries, and marketing pages. And also online orders were expected to increase from retailers and customers, thus the traffic potentially increasing. Migrating the web application from the local host environment to AWS was going to create a secure, repeatable, recoverable cloud architecture using Terraform.



## Networking

I provisoned 4 subnets, 2 public and 2 private. The public subnets were for the Application Load Balancer (inbound traffic) and NAT Gateway (outbound traffic) and the private subnets were for the EC2 (host server) and RDS (database). And each of them was kept at diffferent availabilty zones. Then I provisoned public route tables and associated them with the public subnets. And did the same with private route tables.



## Security Groups

I provisoned Security Groups to implement layered security. The ALB securtiy group to allow port 80 (HTTP) and 443 (HTTPS). The Application Security Group to only allow port 80 (HTTP) from the ALB Security Group. And the Database Security Group to only allow port 3306 from the Application Security Group.



## EC2

I provisioned an Ubuntu EC2 instance to host the migrated WordPress application. The instance was attached to the Application Security Group made earlier and an IAM instance profile that provided access to SSM, CloudWatch, S3, and Secrets Manager. Later on, Apache, PHP, MySQL client, WordPress and CloudWatch Agent were installed on the server to support the application.



## Application Load Balancer

I provisoned an Application Load Balancer across two public subnets to provide a single entry point for web traffic. The ALB used the dedicated security group named above that allowed HTTP and HTTPS traffic from the internet. The incoming HTTP requests were then forwarded through a listener to a target group containing the EC2 WordPress application server.



## S3 Backup Bucket

I provisoned a S3 backup bucket and also separated the different backup purposes into four (wordpress, database, migration-artifacts and recovery). I did that to keep everything centralized and organized at the same time. I blocked all public access, enabled versioning and applied server-side encryption. I also added lifecycle management so that old backups don’t remain in expensive storage forever for cost optimizazion.



##RDS MySQL Database

I provisoned an RDS MySQL database in private subnets for the migrated WordPress Application. The database used encrypted storage and was publicly not accessible. Access was restricted through a dedicated RDS security group that allowed MySQL traffic only through the EC2 application (host). The database’s credentials were managed through Secret Manager.



##Secret Manager

I provisoned a secret container under Secret Manager to put database credentials in and set the recovery window to seven days.



## IAM Role

I provisioned an IAM Role that was later going to get attached to the EC2 instance. I then provisoned a trust policy that was going to allow EC2 instances to assume the IAM role. I provisioned another policy to allow EC2 to communicate with System Manager. This enabled Session Manager and SSM managaement. After that I provisioned another policy to allow CloudWatch Agent on EC2 to publish metrics and logs to CloudWatch. Then I provisioned another S3 and and Secrets Manager Policy to allow listing of the backup bucket, allow EC2 to read and write migration backup objects and allow EC2 to retrieve the database secret respectively.



## Application Deployment

After provisioning the resources through IAM, I connected to the Ubuntu EC2 through Systems Manager Session Manager (I SSHed into the EC2 on the original project and that is my to go to on a regular basis when getting into a server but  it has been a while since I SSMed into a server. So I thought I should give it a shot. Now I like SSHing even more). I installed Apache, PHP, MYSQL Client, AWS CLI, Wordpress, and the CloudWatch Agent mentioned earlier. I configured WordPress to use the private RDS MyQSL database. The EC2 server communicates with RDS over TCP port 3306 through the application and database security groups. The database credentials were securely retrived from Secret Managet using the EC2 IAM role made earlier.



## Connectivity Validation

I validated the following:
-EC2 resolved the RDS endpoint
-The EC2 IAM role successfully accessed the RDS managed secret stored in Secret Manager
-Confirmation of WordPress’ database
-MySQL client established a secure connection to RDS
-TCP port 3306 connectivity was confirmed
-The Application Balancer received public HTTP traffic and requests to the WordPress server through the target group provisoned earlier.



## Monitoring

The CloudWatch Agent was used to collect operating-system and application information such as memory utilization, disk utilization, Apache access logs and Apache error logs. I was able to visualize the health of the migrated application server and it made troubleshooting easier after migration.



## Testing and Validation of Environment

The following was validated after delployment:
-Terraform configuration was succesdfully validated.
-EC2 instance was successsfully registered with Systems Manager.
-EC2 asssumed its IAM role successfully.
-The WordPress Database was accessible.
-MySQL-RDS was authenticated.
-S3 backup access was tested.
-ALB target health was validated.
-WordPress was configured to use RDS database.
-CloudWatch monitoring was confugured.



## Project Results

The application tier and database tier were separated. Then they were migrated into a secure, Terraform managed AWS environment. I implemented least-privilege access, Secrets Manager, S3 backups, CloudWatch monitoring, and an Application Load Balancer. The end result was a more secure, repeatable and recoverable cloud architecture like I had planned.



## Repository Structure

LEGACY-MIGRATION/
|
|–> terraform/
|   |–> provider.tf
|   |–> variables.tf
|   |–> networking.tf
|   |–> security-groups.tf
|   |–> iam.tf
|   |–> ec2.tf
|   |–> alb.tf
|   |–> rds.tf
|   |–> s3.tf
|   `–> outputs.tf
|
|
|–> screenshots/
|–> .gitignore
|–> README.md
