#!/bin/bash
echo "Este es un mensaje" > ~/mensaje.txt

yum update -y # Actualiza el servidor
yum install httpd -y # Instala el servidor web
systemctl enable httpd # Habilita el servicio para que se inicie automáticamente al arrancar el sistema
systemctl start httpd # Inicia el servicio del servidor web