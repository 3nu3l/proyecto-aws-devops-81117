# Obtener el VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Obtener una subnet por defecto del VPC
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
  
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}


# Security group para la instancia
resource "aws_security_group" "ejemplo_iac" {
  name        = var.sg_name
  description = "Security group para ejemplo IAC"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ejemplo_iac.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_api_port_ipv4" {
  security_group_id = aws_security_group.ejemplo_iac.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8000
  ip_protocol       = "tcp"
  to_port           = 8000
}

# Instancia EC2
resource "aws_instance" "ejemplo" {
  ami           = "ami-0ecb62995f68bb549" # Ubuntu 24.04
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.default.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ejemplo_iac.id]

  # Configuración IMDSv2 requerido
  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "ejemplo-iac-instance"
    Environment = "testing"
    ManagedBy   = "terraform"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = true
  subnet_id     = data.aws_subnet.default.id

  tags = {
    Name        = "${var.environment}-ejemplo-iac-instance"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Outputs para mostrar información de la instancia
output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.ejemplo.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.ejemplo.public_ip
}

output "instance_private_ip" {
  description = "IP privada de la instancia"
  value       = aws_instance.ejemplo.private_ip
}

output "instance_public_dns" {
  description = "DNS público de la instancia"
  value       = aws_instance.ejemplo.public_dns
}

output "instance_state" {
  description = "Estado de la instancia"
  value       = aws_instance.ejemplo.instance_state
}

