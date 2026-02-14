variable "instancias" {
  description = "Nombre de las instancias"
  type = list(string) // como uso el toset en el recurso, puedo definir la variable como lista.
  default = ["apache"] // para probar los bloques dinamicos
}

resource "aws_instance" "public_instance" {
  for_each = toset(var.instancias)
  ami = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  subnet_id = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id] // Para asociar el grupo de seguridad a la instancia
  user_data = file("scripts/userdata.sh") // Para ejecutar un script al iniciar la instancia

  tags = {
    "Name" = "${each.value}-${local.sufix}" // Para asignar el nombre a cada instancia, como hacerlo con for_each
  }
}

// COMO CREAR ESTRUCTURAS CONDICIONALES
resource "aws_instance" "monitoring_instance" {
  count = var.enable_monitoring == 1 ? 1 : 0 // CASE type number
  ami = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  subnet_id = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data = file("scripts/userdata.sh")

  tags = {
    "Name" = "Monitoreo-${local.sufix}"
  }
}