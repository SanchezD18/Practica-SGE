# ===========================================
# SCRIPT PARA VER ESTADO DE SERVICIOS
# ===========================================

param(
    [switch]$Detailed,
    [switch]$Health
)

Write-Host "📊 Estado de SGE - Sistema de Gestión Empresarial" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue

# Verificar si Docker está ejecutándose
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Error: Docker Desktop no está ejecutándose" -ForegroundColor Red
    exit 1
}

# Mostrar estado de servicios
Write-Host "🔍 Estado de los servicios:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""

# Mostrar información detallada si se solicita
if ($Detailed) {
    Write-Host "📋 Información detallada:" -ForegroundColor Yellow
    
    # Información de contenedores
    Write-Host "🐳 Contenedores:" -ForegroundColor Cyan
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    Write-Host ""
    
    # Información de volúmenes
    Write-Host "💾 Volúmenes:" -ForegroundColor Cyan
    docker volume ls --filter "name=sge"
    
    Write-Host ""
    
    # Información de redes
    Write-Host "🌐 Redes:" -ForegroundColor Cyan
    docker network ls --filter "name=sge"
    
    Write-Host ""
}

# Verificar salud de los servicios si se solicita
if ($Health) {
    Write-Host "🏥 Verificando salud de los servicios..." -ForegroundColor Yellow
    
    $services = @("odoo", "dolibarr", "odoo-db", "dolibarr-db", "nginx")
    
    foreach ($service in $services) {
        $health = docker-compose exec $service echo "OK" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ $service: Saludable" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $service: No saludable" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

# Mostrar información de acceso
Write-Host "🌐 Acceso a las aplicaciones:" -ForegroundColor Cyan
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

# Verificar si hay problemas
$runningServices = docker-compose ps --services --filter "status=running"
$totalServices = 5  # odoo, dolibarr, odoo-db, dolibarr-db, nginx

if ($runningServices.Count -eq $totalServices) {
    Write-Host ""
    Write-Host "✅ Todos los servicios están ejecutándose correctamente" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️  Algunos servicios no están ejecutándose" -ForegroundColor Yellow
    Write-Host "Servicios ejecutándose: $($runningServices.Count)/$totalServices" -ForegroundColor Yellow
}
