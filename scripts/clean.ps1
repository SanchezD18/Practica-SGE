# ===========================================
# SCRIPT PARA LIMPIAR SISTEMA
# ===========================================

param(
    [switch]$All,
    [switch]$Volumes,
    [switch]$Images,
    [switch]$Networks,
    [switch]$Force
)

Write-Host "🧹 Limpieza de SGE - Sistema de Gestión Empresarial" -ForegroundColor Red
Write-Host "===============================================" -ForegroundColor Red

# Verificar si Docker está ejecutándose
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Error: Docker Desktop no está ejecutándose" -ForegroundColor Red
    exit 1
}

# Mostrar advertencia
Write-Host "⚠️  ADVERTENCIA: Esta operación eliminará datos" -ForegroundColor Red
if (-not $Force) {
    $response = Read-Host "¿Estás seguro de continuar? (s/n)"
    if ($response -ne "s" -and $response -ne "S" -and $response -ne "si" -and $response -ne "Si") {
        Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
        exit 0
    }
}

# Detener servicios
Write-Host "🛑 Deteniendo servicios..." -ForegroundColor Yellow
docker-compose down

# Limpiar contenedores
Write-Host "🗑️  Eliminando contenedores..." -ForegroundColor Yellow
docker-compose down --remove-orphans

# Limpiar volúmenes si se solicita
if ($Volumes -or $All) {
    Write-Host "💾 Eliminando volúmenes..." -ForegroundColor Yellow
    docker-compose down -v
    docker volume prune -f
}

# Limpiar imágenes si se solicita
if ($Images -or $All) {
    Write-Host "🖼️  Eliminando imágenes..." -ForegroundColor Yellow
    docker-compose down --rmi all
    docker image prune -f
}

# Limpiar redes si se solicita
if ($Networks -or $All) {
    Write-Host "🌐 Eliminando redes..." -ForegroundColor Yellow
    docker network prune -f
}

# Limpieza general si se solicita
if ($All) {
    Write-Host "🧹 Limpieza general del sistema Docker..." -ForegroundColor Yellow
    docker system prune -f
    docker system prune -a -f
}

Write-Host ""
Write-Host "✅ Limpieza completada" -ForegroundColor Green

# Mostrar espacio liberado
Write-Host "📊 Espacio en disco:" -ForegroundColor Cyan
docker system df

Write-Host ""
Write-Host "💡 Para volver a iniciar el sistema:" -ForegroundColor Cyan
Write-Host "  .\scripts\start.ps1" -ForegroundColor White
