# RDS - MYSQL
resource "aws_db_subnet_group" "mysql" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# Database Instance
resource "aws_db_instance" "mysql" {
  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "wordpress"
  username = "wpadmin"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  backup_retention_period = 1

  skip_final_snapshot = true

  tags = {
    Name = "${var.project_name}-mysql"
  }
}