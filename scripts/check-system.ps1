# ===========================================
# SCRIPT DE VERIFICACIÓN DEL SISTEMA
# ===========================================

Write-Host "🔍 Verificación del Sistema SGE" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue

$errors = 0
$warnings = 0

# Verificar Docker Desktop
Write-Host "🐳 Verificando Docker Desktop..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "  ✅ Docker encontrado: $dockerVersion" -ForegroundColor Green
    
    # Verificar si Docker está ejecutándose
    $dockerInfo = docker info 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ Docker Desktop está ejecutándose" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Docker Desktop no está ejecutándose" -ForegroundColor Red
        $errors++
    }
} catch {
    Write-Host "  ❌ Docker Desktop no está instalado" -ForegroundColor Red
    $errors++
}

# Verificar Docker Compose
Write-Host "🔧 Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version
    Write-Host "  ✅ Docker Compose encontrado: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Docker Compose no está disponible" -ForegroundColor Red
    $errors++
}

# Verificar archivos necesarios
Write-Host "📁 Verificando archivos del proyecto..." -ForegroundColor Yellow
$requiredFiles = @(
    "docker-compose.yml",
    "env.example",
    "scripts\start.ps1",
    "scripts\stop.ps1",
    "scripts\restart.ps1",
    "scripts\status.ps1",
    "scripts\logs.ps1",
    "scripts\backup.ps1",
    "scripts\clean.ps1"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file - FALTANTE" -ForegroundColor Red
        $errors++
    }
}

# Verificar archivo .env
Write-Host "⚙️  Verificando configuración..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host "  ✅ Archivo .env encontrado" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Archivo .env no encontrado (se creará automáticamente)" -ForegroundColor Yellow
    $warnings++
}

# Verificar puertos
Write-Host "🔌 Verificando puertos..." -ForegroundColor Yellow
$ports = @(80, 443, 8069, 8080)
foreach ($port in $ports) {
    $connection = Test-NetConnection localhost -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet
    if ($connection) {
        Write-Host "  ⚠️  Puerto $port está en uso" -ForegroundColor Yellow
        $warnings++
    } else {
        Write-Host "  ✅ Puerto $port disponible" -ForegroundColor Green
    }
}

# Verificar memoria disponible
Write-Host "💾 Verificando recursos del sistema..." -ForegroundColor Yellow
$memory = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
$memoryGB = [math]::Round($memory / 1GB, 2)
if ($memoryGB -ge 4) {
    Write-Host "  ✅ Memoria RAM: $memoryGB GB (suficiente)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Memoria RAM: $memoryGB GB (recomendado: 4GB+)" -ForegroundColor Yellow
    $warnings++
}

# Verificar PowerShell
Write-Host "💻 Verificando PowerShell..." -ForegroundColor Yellow
$psVersion = $PSVersionTable.PSVersion
Write-Host "  ✅ PowerShell $psVersion" -ForegroundColor Green

# Verificar política de ejecución
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($executionPolicy -eq "Restricted") {
    Write-Host "  ⚠️  Política de ejecución restringida" -ForegroundColor Yellow
    Write-Host "     Ejecuta: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Cyan
    $warnings++
} else {
    Write-Host "  ✅ Política de ejecución: $executionPolicy" -ForegroundColor Green
}

# Resumen
Write-Host ""
Write-Host "📊 Resumen de la Verificación:" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue

if ($errors -eq 0) {
    Write-Host "✅ Sistema listo para usar SGE" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Para iniciar el sistema:" -ForegroundColor Cyan
    Write-Host "  .\scripts\start.ps1" -ForegroundColor White
} else {
    Write-Host "❌ Se encontraron $errors errores críticos" -ForegroundColor Red
    Write-Host "⚠️  Se encontraron $warnings advertencias" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔧 Soluciones:" -ForegroundColor Cyan
    Write-Host "  1. Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop" -ForegroundColor White
    Write-Host "  2. Configura al menos 4GB de RAM en Docker Desktop" -ForegroundColor White
    Write-Host "  3. Ejecuta PowerShell como administrador" -ForegroundColor White
}

if ($warnings -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Advertencias encontradas:" -ForegroundColor Yellow
    Write-Host "  - Algunos puertos pueden estar en uso" -ForegroundColor White
    Write-Host "  - Verifica la configuración de memoria" -ForegroundColor White
}

Write-Host ""
Write-Host "📚 Para más información, consulta README.md" -ForegroundColor Cyan
