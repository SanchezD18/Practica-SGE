# ===========================================
# SCRIPT PARA BACKUP
# ===========================================

param(
    [string]$BackupDir = ".\backups",
    [switch]$IncludeFiles,
    [switch]$Compress
)

Write-Host "💾 Backup de SGE - Sistema de Gestión Empresarial" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Verificar si Docker está ejecutándose
try {
    docker --version | Out-Null
} catch {
    Write-Host "❌ Error: Docker Desktop no está ejecutándose" -ForegroundColor Red
    exit 1
}

# Crear directorio de backup
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Write-Host "📁 Directorio de backup creado: $BackupDir" -ForegroundColor Green
}

# Obtener timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path $BackupDir "sge_backup_$timestamp"

Write-Host "📅 Creando backup: $backupPath" -ForegroundColor Yellow

# Crear directorio de backup
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

# Backup de base de datos de Odoo
Write-Host "🗄️  Haciendo backup de base de datos de Odoo..." -ForegroundColor Yellow
$odooBackupFile = Join-Path $backupPath "odoo_backup.sql"
docker-compose exec -T odoo-db pg_dump -U odoo odoo > $odooBackupFile
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backup de Odoo completado: $odooBackupFile" -ForegroundColor Green
} else {
    Write-Host "❌ Error en backup de Odoo" -ForegroundColor Red
}

# Backup de base de datos de Dolibarr
Write-Host "🗄️  Haciendo backup de base de datos de Dolibarr..." -ForegroundColor Yellow
$dolibarrBackupFile = Join-Path $backupPath "dolibarr_backup.sql"
docker-compose exec -T dolibarr-db mysqldump -u dolibarr -pdolibarr_password_2024 dolibarr > $dolibarrBackupFile
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backup de Dolibarr completado: $dolibarrBackupFile" -ForegroundColor Green
} else {
    Write-Host "❌ Error en backup de Dolibarr" -ForegroundColor Red
}

# Backup de archivos si se solicita
if ($IncludeFiles) {
    Write-Host "📁 Haciendo backup de archivos..." -ForegroundColor Yellow
    
    # Backup de archivos de Odoo
    $odooFilesPath = Join-Path $backupPath "odoo_files"
    New-Item -ItemType Directory -Path $odooFilesPath -Force | Out-Null
    docker-compose exec -T odoo tar -czf - /var/lib/odoo | Set-Content -Path "$odooFilesPath\odoo_files.tar.gz" -Encoding Byte
    
    # Backup de archivos de Dolibarr
    $dolibarrFilesPath = Join-Path $backupPath "dolibarr_files"
    New-Item -ItemType Directory -Path $dolibarrFilesPath -Force | Out-Null
    docker-compose exec -T dolibarr tar -czf - /var/www/html/documents | Set-Content -Path "$dolibarrFilesPath\dolibarr_files.tar.gz" -Encoding Byte
    
    Write-Host "✅ Backup de archivos completado" -ForegroundColor Green
}

# Crear archivo de información del backup
$infoFile = Join-Path $backupPath "backup_info.txt"
$info = @"
Backup de SGE - Sistema de Gestión Empresarial
===============================================
Fecha: $(Get-Date)
Versión: 1.0
Servicios incluidos:
- Odoo ERP
- Dolibarr ERP
- PostgreSQL (Odoo)
- MySQL (Dolibarr)
- Nginx

Archivos incluidos:
- odoo_backup.sql (Base de datos de Odoo)
- dolibarr_backup.sql (Base de datos de Dolibarr)
$($IncludeFiles ? "- odoo_files.tar.gz (Archivos de Odoo)`n- dolibarr_files.tar.gz (Archivos de Dolibarr)" : "")

Para restaurar:
1. Detener servicios: .\scripts\stop.ps1
2. Restaurar bases de datos
3. Restaurar archivos (si aplica)
4. Iniciar servicios: .\scripts\start.ps1
"@

Set-Content -Path $infoFile -Value $info -Encoding UTF8

# Comprimir si se solicita
if ($Compress) {
    Write-Host "🗜️  Comprimiendo backup..." -ForegroundColor Yellow
    $zipFile = "$backupPath.zip"
    Compress-Archive -Path $backupPath -DestinationPath $zipFile -Force
    Remove-Item -Path $backupPath -Recurse -Force
    Write-Host "✅ Backup comprimido: $zipFile" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Backup completado exitosamente" -ForegroundColor Green
Write-Host "📁 Ubicación: $backupPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Para restaurar este backup:" -ForegroundColor Cyan
Write-Host "  .\scripts\restore.ps1 -BackupPath `"$backupPath`"" -ForegroundColor White
