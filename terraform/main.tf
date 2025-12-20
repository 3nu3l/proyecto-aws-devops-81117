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
  name        = "ejemplo-iac-sg"
  description = "Security group para ejemplo IAC"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ejemplo-iac-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ejemplo_iac.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
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
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.default.id
  key_name      = "edit-81117"

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

