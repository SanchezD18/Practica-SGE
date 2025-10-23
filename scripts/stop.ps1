# ===========================================
# SCRIPT PARA DETENER SERVICIOS
# ===========================================

param(
    [switch]$RemoveVolumes,
    [switch]$RemoveImages,
    [switch]$Force
)

Write-Host "🛑 Deteniendo SGE - Sistema de Gestión Empresarial" -ForegroundColor Red
Write-Host "===============================================" -ForegroundColor Red

# Verificar si Docker está ejecutándose
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Error: Docker Desktop no está ejecutándose" -ForegroundColor Red
    exit 1
}

# Mostrar estado actual
Write-Host "🔍 Estado actual de los servicios:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "🛑 Deteniendo servicios..." -ForegroundColor Yellow

if ($RemoveVolumes) {
    Write-Host "⚠️  ADVERTENCIA: Se eliminarán todos los volúmenes (datos)" -ForegroundColor Red
    if (-not $Force) {
        $response = Read-Host "¿Estás seguro? Esto eliminará todos los datos (s/n)"
        if ($response -ne "s" -and $response -ne "S" -and $response -ne "si" -and $response -ne "Si") {
            Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
            exit 0
        }
    }
    docker-compose down -v
} else {
    docker-compose down
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al detener los servicios" -ForegroundColor Red
    exit 1
}

if ($RemoveImages) {
    Write-Host "🗑️  Eliminando imágenes..." -ForegroundColor Yellow
    docker-compose down --rmi all
}

Write-Host "✅ Servicios detenidos correctamente" -ForegroundColor Green

# Mostrar información sobre datos
if (-not $RemoveVolumes) {
    Write-Host ""
    Write-Host "💾 Los datos se han conservado en los volúmenes de Docker" -ForegroundColor Cyan
    Write-Host "Para eliminar todos los datos, usa: .\scripts\stop.ps1 -RemoveVolumes" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Para volver a iniciar los servicios:" -ForegroundColor Cyan
Write-Host "  .\scripts\start.ps1" -ForegroundColor White
