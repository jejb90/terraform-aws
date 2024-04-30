# Documentación del Proyecto Terraform AWS API

Este documento ofrece una guía completa sobre la implementación y gestión de la infraestructura de AWS para una API, utilizando Terraform con un enfoque modular y soporte para múltiples entornos.

## Estructura del Proyecto

La infraestructura está organizada en módulos y entornos. Los módulos comunes se invocan desde configuraciones específicas de entorno para `development` y `production`, lo que permite una fácil reutilización y administración del código.

terraform-aws-api/
├── main.tf # Archivo principal que llama a los módulos según el entorno especificado
├── variables.tf # Define las variables utilizadas en main.tf
├── outputs.tf # Gestiona los outputs generales de la infraestructura
├── backend.tf # Configura el backend para Terraform state
├── environments/
│ ├── production/
│ │ ├── main.tf # Configuración específica de producción que llama a módulos comunes
│ │ ├── variables.tf # Variables parametros de entrada
│ │ └── outputs.tf # Outputs de los recursos
│ └── development/
│ ├── main.tf # Configuración específica de desarrollo
│ ├── variables.tf # Variables parametros de entrada
│ └── outputs.tf # Outputs de los recursos
└── modules/
    ├── vpc/
    │ ├── main.tf # Configuración específica de desarrollo
    │ ├── variables.tf # Variables parametros de entrada
    │ └── outputs.tf # Outputs de los recursos
    ├── ecs/
    │ ├── main.tf # Configuración específica de desarrollo
    │ ├── variables.tf # Variables parametros de entrada
    │ └── outputs.tf # Outputs de los recursos
    ├── rds/
    │ ├── main.tf # Configuración específica de desarrollo
    │ ├── variables.tf # Variables parametros de entrada
    │ └── outputs.tf # Outputs de los recursos
    └── alb/
    │ ├── main.tf # Configuración específica de desarrollo
    │ ├── variables.tf # Variables parametros de entrada
    │ └── outputs.tf # Outputs de los recursos


## Despliegue de la Infraestructura

### Inicialización

Para inicializar Terraform en el entorno deseado (ejemplo: `environments/production`), ejecuta:

```
module "rds" {
  source                = "../../modules/rds"
  environment           = "production"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  db_username           = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
  db_password           = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]
  db_name               = "database"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnets
  security_group_id     = module.rds.db_instance_sg_id
  multi_az              = true
  backup_retention_period = 7
  skip_final_snapshot   = false
  ecs_security_group_id = module.vpc.security_group_id
}

module "ecs" {
  source            = "../../modules/ecs"
  service_name = "prod-serv"
  environment       = "production"
  task_cpu          = "256"
  task_memory       = "512"
  container_cpu     = 256
  container_memory  = 512
  desired_count     = 0
  subnets           = module.vpc.public_subnets
  security_group_id = module.vpc.security_group_id
  target_group_arn  = module.alb.target_group_arn
  min_capacity = 0
  max_capacity = 0
  port_http = 80
}
```

``` bash
terraform init
```
## Planificación
Revisa los cambios planificados ejecutando:

```bash
terraform plan
```
## Aplicación
Aplica los cambios para desplegar la infraestructura con:

``` bash
terraform apply
```

## Destrucción de la Infraestructura
Para eliminar todos los recursos creados:
``` bash
terraform destroy
```

# Seguridad y Escalabilidad
## Seguridad
## Grupos de Seguridad (SGs): Cada módulo configura sus propios SGs, definiendo reglas de entrada y salida estrictas basadas en las necesidades exactas de cada parte de la infraestructura. Esto asegura que solo el tráfico permitido pueda acceder a los recursos.
## IAM Roles: Utilizados para garantizar que cada servicio tenga únicamente los permisos necesarios para operar, limitando la superficie de ataque.
## Encriptación: Implementada tanto en reposo como en tránsito para proteger los datos sensibles.

# Escalabilidad
## Auto Scaling: Configurado en los módulos de ECS para ajustar automáticamente el número de instancias según la demanda.
## Balanceadores de Carga (ALBs): Distribuyen el tráfico entrante de manera eficiente y mejoran la disponibilidad y respuesta ante fallos.


# Conexión al Bastión
Para acceder a los recursos internos a través del bastión:

``` bash
ssh -i key-pair.pem ubuntu@ec2-3-80-212-223.compute-1.amazonaws.com
```

# Conexión a las Bases de Datos
Utiliza los siguientes parámetros para conectar a la base de datos RDS:

Host: production-rds-db.cle42am6gk62.us-east-1.rds.amazonaws.com
Usuario: rickdb
Contraseña: 6.B_L4t6)g2g
