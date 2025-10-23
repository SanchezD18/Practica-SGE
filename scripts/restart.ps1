# ===========================================
# SCRIPT PARA REINICIAR SERVICIOS
# ===========================================

param(
    [switch]$Build,
    [switch]$Force
)

Write-Host "🔄 Reiniciando SGE - Sistema de Gestión Empresarial" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue

# Verificar si Docker está ejecutándose
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Error: Docker Desktop no está ejecutándose" -ForegroundColor Red
    exit 1
}

# Detener servicios
Write-Host "🛑 Deteniendo servicios..." -ForegroundColor Yellow
if ($Force) {
    docker-compose down -v
} else {
    docker-compose down
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al detener los servicios" -ForegroundColor Red
    exit 1
}

# Esperar un momento
Start-Sleep -Seconds 3

# Iniciar servicios
Write-Host "🚀 Iniciando servicios..." -ForegroundColor Yellow
if ($Build) {
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

# Verificar estado
Write-Host "🔍 Verificando estado de los servicios..." -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "✅ Servicios reiniciados correctamente" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Acceso a las aplicaciones:" -ForegroundColor Cyan
Write-Host "  • Página principal: http://localhost" -ForegroundColor White
Write-Host "  • Odoo ERP: http://localhost:8069" -ForegroundColor White
Write-Host "  • Dolibarr ERP: http://localhost:8080" -ForegroundColor White
