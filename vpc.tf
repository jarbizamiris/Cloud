resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "vpc_virginia-${local.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id // Dependencia IMPLICITA, se crea la VPC antes de crear la subnet
  cidr_block = var.subnets[0]
  map_public_ip_on_launch = true // Para que los recursos que se desplieguen en esta subnet tengan IP publicas automaticamente
  tags = {
    "Name" = "public_subnet-${local.sufix}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "private_subnet-${local.sufix}"
  }
  depends_on = [
    aws_subnet.public_subnet // Dependencia EXPLICITA, se crea la subnet publica antes de crear la subnet privada
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0" // Default route, para que todo el tráfico que no tenga una ruta específica se dirija a la puerta de enlace de internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_crt-${local.sufix}"
  }
}

// Asociamos la tabla de enrutamiento a la subnet publica, para que los recursos que se desplieguen en esa subnet tengan acceso a internet

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      description      = "Port http ${ingress.value} over internet"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.sg_ingress_cidr]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" // -1 significa todos los protocolos
    cidr_blocks      = ["0.0.0.0/0"] // Permite el tráfico de salida a cualquier dirección IPv4
    ipv6_cidr_blocks = ["::/0"] // Permite el tráfico de salida a cualquier dirección IPv6
  }

  tags = {
    Name = "Public Instance SG-${local.sufix}"
  }
}
