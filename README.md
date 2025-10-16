# Práctica Docker - Odoo y Dolibarr

Este proyecto contiene la configuración Docker para ejecutar Odoo y Dolibarr en contenedores separados con sus respectivas bases de datos.

## Estructura del Proyecto

```
SGE-PRACTICA-DOCKER/
├── docker-compose.yml          # Configuración principal de Docker Compose
├── env.example                 # Archivo de ejemplo para variables de entorno
├── README.md                   # Este archivo
├── odoo/
│   ├── addons/                 # Módulos personalizados de Odoo
│   ├── config/
│   │   └── odoo.conf          # Configuración de Odoo
│   └── logs/                  # Logs de Odoo
├── dolibarr/
│   ├── config/                # Configuración de Dolibarr
│   └── logs/                  # Logs de Dolibarr
└── nginx/
    ├── nginx.conf             # Configuración principal de Nginx
    └── conf.d/
        ├── odoo.conf          # Configuración específica para Odoo
        └── dolibarr.conf      # Configuración específica para Dolibarr
```

## Requisitos Previos

- Docker Engine 20.10+
- Docker Compose 2.0+
- Al menos 4GB de RAM disponible
- Puertos 80, 443, 8069, 8080 libres

## Instalación y Configuración

### 1. Clonar o descargar el proyecto

```bash
# Si tienes git
git clone <url-del-repositorio>
cd SGE-PRACTICA-DOCKER

# O simplemente descarga y extrae los archivos
```

### 2. Configurar variables de entorno

```bash
# Copia el archivo de ejemplo
cp env.example .env

# Edita las variables según tus necesidades
nano .env
```

### 3. Iniciar los servicios

```bash
# Construir e iniciar todos los servicios
docker-compose up -d

# Ver el estado de los contenedores
docker-compose ps

# Ver los logs en tiempo real
docker-compose logs -f
```

## Acceso a las Aplicaciones

### Odoo
- **URL**: http://localhost:8069
- **Usuario por defecto**: admin
- **Contraseña**: admin_password_2024 (configurable en .env)

### Dolibarr
- **URL**: http://localhost:8080
- **Usuario por defecto**: admin
- **Contraseña**: admin_password_2024 (configurable en .env)

### Nginx (Proxy Reverso)
- **URL**: http://localhost
- Redirige automáticamente a Odoo

## Configuración de Base de Datos

### Odoo (PostgreSQL)
- **Host**: odoo-db
- **Puerto**: 5432
- **Base de datos**: odoo
- **Usuario**: odoo
- **Contraseña**: odoo_password_2024

### Dolibarr (MySQL)
- **Host**: dolibarr-db
- **Puerto**: 3306
- **Base de datos**: dolibarr
- **Usuario**: dolibarr
- **Contraseña**: dolibarr_password_2024

## Comandos Útiles

### Gestión de Contenedores
```bash
# Iniciar servicios
docker-compose up -d

# Parar servicios
docker-compose down

# Reiniciar un servicio específico
docker-compose restart odoo

# Ver logs de un servicio
docker-compose logs odoo

# Ejecutar comandos en un contenedor
docker-compose exec odoo bash
```

### Gestión de Volúmenes
```bash
# Ver volúmenes
docker volume ls

# Eliminar volúmenes (¡CUIDADO! Esto borra los datos)
docker-compose down -v
```

### Backup y Restore
```bash
# Backup de la base de datos de Odoo
docker-compose exec odoo-db pg_dump -U odoo odoo > backup_odoo.sql

# Backup de la base de datos de Dolibarr
docker-compose exec dolibarr-db mysqldump -u dolibarr -p dolibarr > backup_dolibarr.sql
```

## Personalización

### Agregar Módulos a Odoo
1. Coloca los módulos en la carpeta `odoo/addons/`
2. Reinicia el contenedor: `docker-compose restart odoo`
3. Actualiza la lista de aplicaciones en Odoo

### Modificar Configuración
- **Odoo**: Edita `odoo/config/odoo.conf`
- **Dolibarr**: Los archivos de configuración se generan automáticamente
- **Nginx**: Edita los archivos en `nginx/conf.d/`

## Solución de Problemas

### Verificar Estado de los Servicios
```bash
# Ver estado de todos los contenedores
docker-compose ps

# Ver logs de errores
docker-compose logs --tail=50
```

### Problemas Comunes

1. **Puerto en uso**: Cambia los puertos en el archivo `.env`
2. **Memoria insuficiente**: Aumenta la memoria disponible para Docker
3. **Base de datos no conecta**: Verifica que las contraseñas coincidan

### Limpiar Todo
```bash
# Parar y eliminar contenedores, redes y volúmenes
docker-compose down -v

# Eliminar imágenes (opcional)
docker-compose down --rmi all
```

## Seguridad

⚠️ **IMPORTANTE**: Esta configuración es para desarrollo/práctica. Para producción:

1. Cambia todas las contraseñas por defecto
2. Configura SSL/TLS
3. Usa variables de entorno seguras
4. Configura firewall
5. Implementa backup automático

## Soporte

Para problemas específicos de la práctica, consulta:
- Documentación oficial de Odoo
- Documentación oficial de Dolibarr
- Logs de los contenedores: `docker-compose logs <servicio>`
