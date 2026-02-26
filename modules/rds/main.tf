resource "aws_db_subnet_group" "rds" {
  name       = "${var.env}-rds-subnet"
  subnet_ids = var.subnets
}

resource "aws_db_instance" "strapi" {
  identifier        = "${var.env}-strapi-db"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "strapi"
  password          = "StrapiPass123"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.rds.name
  publicly_accessible  = false
}
