
# Creating the Database using RDS

resource "aws_db_instance" "two_tier_DB_instance" {


    allocated_storage = 5

    storage_type = "gp2"

    engine = "mysql"

    engine_version = "5.7"
 
    instance_class = "db.t2.micro"

    db_security_group_name = "two_tier_DB_subnet"

    vpc_security_group_ids = [aws_security_group.two_tier_db_SG.id]

    parameter_group_name = "default.mysql5.7"

    db_name = "two_tier_DB_instance"

    username = "admin"

    password = "password"

    allow_major_version_upgrade = true 

    auto_minor_version_upgrade = true

    backup_retention_period = 35

    backup_window = "22:00-23:00"

    maintenance_window = "Sat:00:00-Sat:03:00"

    multi_az = false

    skip_final_snapshot = true





}