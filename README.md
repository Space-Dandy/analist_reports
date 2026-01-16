# 📱 analist_reports

> Una solución multiplataforma para reportes de incidentes, construida con Flutter y ASP.NET Core

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![C Sharp](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)](https://docs.microsoft.com/en-us/dotnet/csharp/)
[![.NET](https://img.shields.io/badge/.NET-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)

## 🎯 ¿Qué es esto?

**analist_reports** es una aplicación completa para gestionar reportes de incidentes. Incluye una app móvil/escritorio hecha en Flutter y un backend robusto en ASP.NET Core con autenticación JWT.

---

## 📂 Estructura del proyecto

### 🎨 Frontend - Flutter

**`reports_app`** — Aplicación multiplataforma (móvil, web, escritorio)

- 🚀 **Punto de entrada**: [`MyApp`](reports_app/lib/main.dart) en [main.dart](reports_app/lib/main.dart)
- 📱 **Pantallas principales**:
  - Lista de incidentes: [incidents_screen.dart](reports_app/lib/screens/incidents_screen.dart)
  - Detalles de incidente: [incident_details.dart](reports_app/lib/screens/incident_details.dart)
- 🔌 **Servicios**:
  - Incidentes: [incidents_service.dart](reports_app/lib/services/incidents_service.dart)
  - Usuarios: [user_service.dart](reports_app/lib/services/user_service.dart)

### ⚙️ Backend - ASP.NET Core

**`reports-backend`** — API Web en C#

- 🚀 **Punto de entrada**: [Program.cs](reports-backend/Program.cs)
- 🎮 **Controladores**:
  - Incidentes: [IncidentsController.cs](reports-backend/src/Controllers/IncidentsController.cs)
  - Usuarios: [UsersController.cs](reports-backend/src/Controllers/UsersController.cs)
- 📦 **Datos**:
  - Repositorios: [/Repositories](reports-backend/src/Repositories)
  - Modelos: [/Models](reports-backend/src/Models)

---

## 🚀 Cómo ejecutar el proyecto

### 🔧 Backend (ASP.NET Core)

1. Configura tu cadena de conexión y JWT en [appsettings.json](reports-backend/appsettings.json)
2. Abre tu terminal y ejecuta:

```bash
cd reports-backend
dotnet run
```

### 📱 Frontend (Flutter)

1. Actualiza la URL del API en [base_url.dart](reports_app/lib/utils/base_url.dart) si es necesario
2. Ejecuta la aplicación:

```bash
cd reports_app
flutter pub get
flutter run
```

---

## ✨ Características principales

- 🔐 **Autenticación JWT** - Sistema seguro de tokens (ver [TokenService.cs](reports-backend/src/Services/TokenService.cs))
- 📸 **Subida de imágenes** - Las imágenes se guardan en `wwwroot/images`
- 🔄 **API RESTful** - Endpoints completos para CRUD de incidentes
- 🎨 **UI multiplataforma** - Una sola base de código para móvil, web y escritorio
- 📊 **Arquitectura limpia** - Patrón repositorio en el backend

---

## 📝 Archivos importantes

| Componente          | Archivo                                                                          | Descripción                       |
| ------------------- | -------------------------------------------------------------------------------- | --------------------------------- |
| 🎨 App Flutter      | [main.dart](reports_app/lib/main.dart)                                           | Punto de entrada de la aplicación |
| ⚙️ API Backend      | [Program.cs](reports-backend/Program.cs)                                         | Configuración del servidor        |
| 📋 Controlador      | [IncidentsController.cs](reports-backend/src/Controllers/IncidentsController.cs) | Lógica de incidentes              |
| 🔌 Servicio Flutter | [incidents_service.dart](reports_app/lib/services/incidents_service.dart)        | Comunicación con API              |

---

## 🤝 Contribuir

1. Ejecuta y prueba primero las APIs del backend
2. Apunta el cliente Flutter al backend en ejecución
3. Sigue los patrones de código existentes:
   - Backend: Controllers → Repositories
   - Frontend: Screens → Services → Widgets

---

## 💡 Notas técnicas

- Las imágenes se procesan y almacenan en el servidor
- Autenticación basada en tokens JWT
- Comunicación cliente-servidor vía HTTP/HTTPS
- Base de datos configurada con Entity Framework Core

---

<div align="center">

**Hecho con ❤️ usando Flutter y C#**

</div>
