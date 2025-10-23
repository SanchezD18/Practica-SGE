# 🏢 SGE - Sistema de Gestión Empresarial
## Práctica Docker - Odoo y Dolibarr (Optimizado para Windows)

Este proyecto contiene la configuración Docker optimizada para **Docker Desktop en Windows** para ejecutar Odoo y Dolibarr en contenedores separados con sus respectivas bases de datos.

## 🎯 Características Principales

- ✅ **Optimizado para Windows**: Configuración específica para Docker Desktop
- 🚀 **Scripts de PowerShell**: Automatización completa con scripts fáciles de usar
- 🔧 **Configuración avanzada**: Nginx, health checks, y optimizaciones de rendimiento
- 📊 **Monitoreo integrado**: Scripts para logs, estado y backup
- 🛡️ **Seguridad**: Configuración de rate limiting y headers de seguridad

## 📁 Estructura del Proyecto

```
SGE-PRACTICA-DOCKER/
├── docker-compose.yml          # Configuración principal optimizada para Windows
├── env.example                 # Variables de entorno con configuraciones para Windows
├── README.md                   # Este archivo
├── scripts/                    # Scripts de PowerShell para automatización
│   ├── start.ps1              # Iniciar servicios
│   ├── stop.ps1               # Detener servicios
│   ├── restart.ps1             # Reiniciar servicios
│   ├── logs.ps1               # Ver logs
│   ├── status.ps1             # Estado de servicios
│   ├── backup.ps1             # Backup de datos
│   └── clean.ps1              # Limpiar sistema
├── odoo/
│   ├── addons/                 # Módulos personalizados de Odoo
│   ├── config/
│   │   └── odoo.conf          # Configuración optimizada para Windows
│   └── logs/                  # Logs de Odoo
├── dolibarr/
│   ├── config/                # Configuración de Dolibarr
│   └── logs/                  # Logs de Dolibarr
├── nginx/
│   ├── nginx.conf             # Configuración principal optimizada
│   ├── ssl/                   # Certificados SSL (opcional)
│   └── conf.d/
│       ├── odoo.conf          # Configuración específica para Odoo
│       └── dolibarr.conf      # Configuración específica para Dolibarr
├── postgres-init/             # Scripts de inicialización de PostgreSQL
└── mysql-init/                # Scripts de inicialización de MySQL
```

## 🔧 Requisitos Previos

### Para Windows:
- **Windows 10/11** (64-bit)
- **Docker Desktop** 4.0+ (instalado y ejecutándose)
- **PowerShell** 5.1+ (incluido en Windows)
- **Al menos 4GB de RAM** disponible para Docker
- **Puertos libres**: 80, 443, 8069, 8080

### Instalación de Docker Desktop:
1. Descarga Docker Desktop desde: https://www.docker.com/products/docker-desktop
2. Instala y reinicia el sistema
3. Inicia Docker Desktop
4. Configura al menos 4GB de RAM en Settings > Resources

## 🚀 Instalación y Configuración Rápida

### 1. Preparar el proyecto

```powershell
# Navegar al directorio del proyecto
cd Practica-SGE

# Copiar archivo de configuración
Copy-Item env.example .env
```

### 2. Iniciar servicios (Método Fácil)

```powershell
# Usar el script de PowerShell (RECOMENDADO)
.\scripts\start.ps1

# O con opciones adicionales
.\scripts\start.ps1 -Build -Verbose
```

### 3. Verificar que todo funciona

```powershell
# Ver estado de servicios
.\scripts\status.ps1

# Ver logs si hay problemas
.\scripts\logs.ps1
```

## 🌐 Acceso a las Aplicaciones

### URLs de Acceso:
- **🏠 Página Principal**: http://localhost (con enlaces a ambas aplicaciones)
- **📊 Odoo ERP**: http://localhost:8069
- **💼 Dolibarr ERP**: http://localhost:8080

### 🔑 Credenciales por Defecto:
- **Usuario**: `admin`
- **Contraseña**: `admin_password_2024`

## 🛠️ Scripts de PowerShell (Método Recomendado)

### Scripts Disponibles:

| Script | Descripción | Uso |
|--------|-------------|-----|
| `start.ps1` | Iniciar todos los servicios | `.\scripts\start.ps1` |
| `stop.ps1` | Detener servicios | `.\scripts\stop.ps1` |
| `restart.ps1` | Reiniciar servicios | `.\scripts\restart.ps1` |
| `status.ps1` | Ver estado de servicios | `.\scripts\status.ps1` |
| `logs.ps1` | Ver logs de servicios | `.\scripts\logs.ps1` |
| `backup.ps1` | Hacer backup de datos | `.\scripts\backup.ps1` |
| `clean.ps1` | Limpiar sistema Docker | `.\scripts\clean.ps1` |

### Ejemplos de Uso:

```powershell
# Iniciar servicios con construcción
.\scripts\start.ps1 -Build

# Ver logs en tiempo real
.\scripts\logs.ps1 -Follow

# Ver logs de un servicio específico
.\scripts\logs.ps1 -Service odoo -Follow

# Hacer backup completo
.\scripts\backup.ps1 -IncludeFiles -Compress

# Ver estado detallado
.\scripts\status.ps1 -Detailed -Health

# Limpiar todo (¡CUIDADO!)
.\scripts\clean.ps1 -All -Force
```

## 🗄️ Configuración de Base de Datos

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

## 🔧 Comandos Docker Compose (Alternativo)

Si prefieres usar comandos Docker Compose directamente:

```powershell
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

# Ver estado de servicios
docker-compose ps

# Ver volúmenes
docker volume ls
```

## 💾 Backup y Restore

### Backup Automático (Recomendado):
```powershell
# Backup completo con archivos
.\scripts\backup.ps1 -IncludeFiles -Compress

# Backup solo de bases de datos
.\scripts\backup.ps1
```

### Backup Manual:
```powershell
# Backup de Odoo
docker-compose exec odoo-db pg_dump -U odoo odoo > backup_odoo.sql

# Backup de Dolibarr
docker-compose exec dolibarr-db mysqldump -u dolibarr -p dolibarr > backup_dolibarr.sql
```

## 🎨 Personalización

### Agregar Módulos a Odoo
1. Coloca los módulos en la carpeta `odoo/addons/`
2. Reinicia el contenedor: `.\scripts\restart.ps1` o `docker-compose restart odoo`
3. Actualiza la lista de aplicaciones en Odoo

### Modificar Configuración
- **Odoo**: Edita `odoo/config/odoo.conf`
- **Dolibarr**: Los archivos de configuración se generan automáticamente
- **Nginx**: Edita los archivos en `nginx/conf.d/`
- **Variables de entorno**: Edita el archivo `.env`

### Configuración Avanzada
- **SSL/TLS**: Coloca certificados en `nginx/ssl/`
- **Proxy corporativo**: Configura variables HTTP_PROXY en `.env`
- **Memoria**: Ajusta límites en `docker-compose.yml`

## 🔧 Solución de Problemas

### Verificar Estado de los Servicios
```powershell
# Ver estado detallado
.\scripts\status.ps1 -Detailed -Health

# Ver logs de errores
.\scripts\logs.ps1 -Lines 100

# Ver logs en tiempo real
.\scripts\logs.ps1 -Follow
```

### Problemas Comunes en Windows

1. **Docker Desktop no inicia**:
   - Verifica que Hyper-V esté habilitado
   - Reinicia el sistema
   - Ejecuta Docker Desktop como administrador

2. **Puerto en uso**:
   - Cambia los puertos en el archivo `.env`
   - Usa `netstat -an | findstr :8069` para verificar puertos

3. **Memoria insuficiente**:
   - Aumenta la memoria en Docker Desktop Settings > Resources
   - Cierra otras aplicaciones

4. **Base de datos no conecta**:
   - Verifica que las contraseñas coincidan en `.env`
   - Espera a que las bases de datos estén listas (health checks)

5. **Scripts de PowerShell no ejecutan**:
   - Ejecuta: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
   - O ejecuta PowerShell como administrador

### Limpiar Todo
```powershell
# Limpieza completa (¡CUIDADO!)
.\scripts\clean.ps1 -All -Force

# O manualmente
docker-compose down -v
docker system prune -a -f
```

## 🛡️ Seguridad

⚠️ **IMPORTANTE**: Esta configuración es para desarrollo/práctica. Para producción:

1. **Cambia todas las contraseñas** por defecto en `.env`
2. **Configura SSL/TLS** colocando certificados en `nginx/ssl/`
3. **Usa variables de entorno seguras** y no hardcodees contraseñas
4. **Configura firewall** para limitar acceso
5. **Implementa backup automático** con `.\scripts\backup.ps1`

### Configuración de Seguridad Avanzada:
- Rate limiting configurado en nginx
- Headers de seguridad
- Logs de acceso y errores
- Health checks para monitoreo

## 📚 Soporte y Documentación

### Para problemas específicos:
- **Logs del sistema**: `.\scripts\logs.ps1 -Follow`
- **Estado de servicios**: `.\scripts\status.ps1 -Detailed`
- **Documentación oficial**: 
  - [Odoo](https://www.odoo.com/documentation)
  - [Dolibarr](https://wiki.dolibarr.org/)
  - [Docker Desktop](https://docs.docker.com/desktop/windows/)

### Comandos de Diagnóstico:
```powershell
# Ver recursos del sistema
docker system df

# Ver uso de memoria
docker stats

# Ver logs de un servicio específico
.\scripts\logs.ps1 -Service odoo -Follow

# Verificar conectividad
Test-NetConnection localhost -Port 8069
Test-NetConnection localhost -Port 8080
```

## 🎉 ¡Disfruta usando SGE!

Este sistema está optimizado para Windows y Docker Desktop. Los scripts de PowerShell hacen que sea muy fácil de usar. ¡No dudes en explorar todas las funcionalidades!
