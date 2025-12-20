variable "sg_name" {
    description = "Nombre del grupo de seguridad"
    type = string
}

variable "environment" {
    description = "Nombre del entorno"
    type = string
}

variable "allowed_cidr_blocks" {
    description = "CIDR blocks permitidos"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "ssh_port" {
    description = "Puerto SSH"
    type = number
    default = 22
}

variable "key_name" {
    description = "Nombre de la llave SSH"
    type = string
    default = "edit-81117"
}

variable "instance_type" {
    description = "Tipo de instancia"
    type = string
    default = "t3.micro"
}