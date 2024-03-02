# This is an AWS RDS Aurora Code

locals {

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

resource "aws_db_subnet_group" "aurora" {
  name        = "${var.project}-aurora-subnet"
  description = "Our main group of subnets"
  subnet_ids  = var.subnets
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier              = "${var.project}-aurora"
  master_username                 = var.rds_username
  master_password                 = var.password
  backup_retention_period         = var.backup_retention_period
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = "${var.project}-${var.environment}${var.tag}-aurora-final-${md5(timestamp())}"
  availability_zones              = local.availability_zones
  db_subnet_group_name            = aws_db_subnet_group.aurora.id
  vpc_security_group_ids          = [aws_security_group.sg_aurora.id]
  storage_type                    = var.storage_type
  storage_encrypted               = var.storage_encrypted
  apply_immediately               = var.apply_immediately
  #db_cluster_parameter_group_name = var.cluster_parameter_group_name
  engine                          = var.engine
  engine_version                  = var.engine_version
   snapshot_identifier             = var.snapshot_identifier

  tags = merge({
    Name        = "${var.project}-${var.environment}${var.tag}-aurora"
    Environment = var.environment
    Project     = var.project
    },
    var.extra_tags
  )

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                        = var.amount_of_instances
  identifier                   = "${var.project}-aurora-instance"
  cluster_identifier           = aws_rds_cluster.aurora.id
  instance_class               = length(var.instance_size_override) > 0 ? var.instance_size_override[count.index] : var.size
  promotion_tier               = length(var.instance_promotion_tiers) > 0 ? var.instance_promotion_tiers[count.index] : null
  db_subnet_group_name         = aws_db_subnet_group.aurora.id
  apply_immediately            = var.apply_immediately
  performance_insights_enabled = var.performance_insights_enabled

  # To set the `db_parameter_group_name` we'll concat the instance_parameter_group_name variable with the aurora_mysql resource name as one of the two will be an empty string
  db_parameter_group_name = "${var.instance_parameter_group_name}"
  engine                  = var.engine
  engine_version          = var.engine_version

  tags = {
    Name        = var.rds_instance_name_overrides == null ? "${var.project}-${var.environment}${var.tag}-aurora${format("%02d", count.index + 1)}" : var.rds_instance_name_overrides[count.index]
    Environment = var.environment
    Project     = var.project
  }
}