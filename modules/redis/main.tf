resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.environment}-cache-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redis_sg" {
  name = "${var.environment}-redis-sg"
  description = "${var.environment} Security Group"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment}-redis-sg"
    Environment =  var.environment
  }

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 6379
      to_port   = 6379
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.environment}-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  apply_immediately    = true
  subnet_group_name = aws_elasticache_subnet_group.default.id
  security_group_ids = [aws_security_group.redis_sg.id]
}