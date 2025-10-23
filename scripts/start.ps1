# ===========================================
# SCRIPT DE INICIO PARA DOCKER DESKTOP EN WINDOWS
# ===========================================

param(
    [switch]$Build,
    [switch]$Force,
    [switch]$Verbose
)

Write-Host "🚀 Iniciando SGE - Sistema de Gestión Empresarial" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Verificar si Docker Desktop está ejecutándose
Write-Host "🔍 Verificando Docker Desktop..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Docker Desktop no está instalado o no está ejecutándose" -ForegroundColor Red
    Write-Host "Por favor, instala Docker Desktop desde: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar si Docker Compose está disponible
try {
    $composeVersion = docker-compose --version
    Write-Host "✅ Docker Compose encontrado: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Docker Compose no está disponible" -ForegroundColor Red
    exit 1
}

# Verificar si existe el archivo .env
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creando archivo .env desde env.example..." -ForegroundColor Yellow
    Copy-Item "env.example" ".env"
    Write-Host "✅ Archivo .env creado. Puedes editarlo si necesitas cambiar la configuración." -ForegroundColor Green
}

# Crear directorios necesarios
Write-Host "📁 Creando directorios necesarios..." -ForegroundColor Yellow
$directories = @(
    "odoo\addons",
    "odoo\config", 
    "odoo\logs",
    "dolibarr\config",
    "dolibarr\logs",
    "nginx\ssl",
    "postgres-init",
    "mysql-init"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ Creado: $dir" -ForegroundColor Green
    }
}

# Construir imágenes si se solicita
if ($Build) {
    Write-Host "🔨 Construyendo imágenes..." -ForegroundColor Yellow
    docker-compose build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error al construir las imágenes" -ForegroundColor Red
        exit 1
    }
}

# Detener contenedores existentes si se fuerza
if ($Force) {
    Write-Host "🛑 Deteniendo contenedores existentes..." -ForegroundColor Yellow
    docker-compose down -v
}

# Iniciar servicios
Write-Host "🚀 Iniciando servicios..." -ForegroundColor Yellow
if ($Verbose) {
    docker-compose up -d --build
} else {
    docker-compose up -d
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al iniciar los servicios" -ForegroundColor Red
    exit 1
}

# Esperar a que los servicios estén listos
Write-Host "⏳ Esperando a que los servicios estén listos..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Verificar estado de los servicios
Write-Host "🔍 Verificando estado de los servicios..." -ForegroundColor Yellow
docker-compose ps

# Mostrar información de acceso
Write-Host ""
Write-Host "🎉 ¡SGE iniciado correctamente!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Acceso a las aplicaciones:" -ForegroundColor Cyan
Write-Host "  • Página principal: http://localhost" -ForegroundColor White
Write-Host "  • Odoo ERP: http://localhost:8069" -ForegroundColor White
Write-Host "  • Dolibarr ERP: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Credenciales por defecto:" -ForegroundColor Cyan
Write-Host "  • Usuario: admin" -ForegroundColor White
Write-Host "  • Contraseña: admin_password_2024" -ForegroundColor White
Write-Host ""
Write-Host "📋 Comandos útiles:" -ForegroundColor Cyan
Write-Host "  • Ver logs: .\scripts\logs.ps1" -ForegroundColor White
Write-Host "  • Parar servicios: .\scripts\stop.ps1" -ForegroundColor White
Write-Host "  • Reiniciar: .\scripts\restart.ps1" -ForegroundColor White
Write-Host "  • Backup: .\scripts\backup.ps1" -ForegroundColor White
Write-Host ""

# Abrir navegador
$response = Read-Host "¿Deseas abrir el navegador ahora? (s/n)"
if ($response -eq "s" -or $response -eq "S" -or $response -eq "si" -or $response -eq "Si") {
    Start-Process "http://localhost"
}
