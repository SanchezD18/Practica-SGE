# 🚀 Guía de Inicio Rápido - SGE para Windows

## ⚡ Inicio en 3 Pasos

### 1. Preparar el Sistema
```powershell
# Navegar al directorio
cd Practica-SGE

# Copiar configuración
Copy-Item env.example .env
```

### 2. Iniciar Todo
```powershell
# Método fácil (RECOMENDADO)
.\scripts\start.ps1
```

### 3. Acceder a las Aplicaciones
- **🏠 Página Principal**: http://localhost
- **📊 Odoo**: http://localhost:8069
- **💼 Dolibarr**: http://localhost:8080

**Credenciales**: `admin` / `admin_password_2024`

## 🛠️ Comandos Esenciales

| Acción | Comando |
|--------|---------|
| Iniciar | `.\scripts\start.ps1` |
| Parar | `.\scripts\stop.ps1` |
| Reiniciar | `.\scripts\restart.ps1` |
| Ver estado | `.\scripts\status.ps1` |
| Ver logs | `.\scripts\logs.ps1` |
| Backup | `.\scripts\backup.ps1` |

## 🔧 Si Algo No Funciona

1. **Verificar Docker Desktop**: Debe estar ejecutándose
2. **Ver logs**: `.\scripts\logs.ps1 -Follow`
3. **Reiniciar**: `.\scripts\restart.ps1`
4. **Limpiar todo**: `.\scripts\clean.ps1 -All -Force`

## 📞 Soporte Rápido

- **Estado del sistema**: `.\scripts\status.ps1 -Detailed`
- **Logs en tiempo real**: `.\scripts\logs.ps1 -Follow`
- **Verificar puertos**: `Test-NetConnection localhost -Port 8069`

¡Listo! 🎉
