# ===========================================
# SCRIPT PARA VER LOGS
# ===========================================

param(
    [string]$Service = "",
    [switch]$Follow,
    [int]$Lines = 50
)

Write-Host "📋 Logs de SGE - Sistema de Gestión Empresarial" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue

# Verificar si Docker está ejecutándose
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Error: Docker Desktop no está ejecutándose" -ForegroundColor Red
    exit 1
}

# Verificar si los servicios están ejecutándose
$runningServices = docker-compose ps --services --filter "status=running"
if (-not $runningServices) {
    Write-Host "❌ No hay servicios ejecutándose" -ForegroundColor Red
    Write-Host "Inicia los servicios primero con: .\scripts\start.ps1" -ForegroundColor Yellow
    exit 1
}

# Mostrar servicios disponibles
Write-Host "🔍 Servicios disponibles:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""

# Mostrar logs
if ($Service) {
    Write-Host "📋 Mostrando logs de $Service..." -ForegroundColor Yellow
    if ($Follow) {
        docker-compose logs -f --tail=$Lines $Service
    } else {
        docker-compose logs --tail=$Lines $Service
    }
} else {
    Write-Host "📋 Mostrando logs de todos los servicios..." -ForegroundColor Yellow
    if ($Follow) {
        docker-compose logs -f --tail=$Lines
    } else {
        docker-compose logs --tail=$Lines
    }
}

Write-Host ""
Write-Host "💡 Consejos:" -ForegroundColor Cyan
Write-Host "  • Para seguir logs en tiempo real: .\scripts\logs.ps1 -Follow" -ForegroundColor White
Write-Host "  • Para logs de un servicio específico: .\scripts\logs.ps1 -Service odoo" -ForegroundColor White
Write-Host "  • Para más líneas: .\scripts\logs.ps1 -Lines 100" -ForegroundColor White
Write-Host ""
Write-Host "📋 Servicios disponibles: odoo, dolibarr, odoo-db, dolibarr-db, nginx" -ForegroundColor Cyan
