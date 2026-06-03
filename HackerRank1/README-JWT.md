# Investigación 2 - JWT Auth (Backend)

API .NET 6 con autenticación JWT y credenciales hardcoded (sin BD de usuarios).

## Repositorios

- **Backend:** https://github.com/yeissonalb/Investigaci-n002Backend.git
- **Frontend:** https://github.com/yeissonalb/Investigaci-n02.git

## Despliegue

| Entorno | URL |
|---------|-----|
| API desplegada | _Pendiente: agregar URL de Azure/Render/Railway_ |
| Frontend desplegado | _Pendiente: agregar URL de Netlify/Vercel_ |

## Desarrollo local

```bash
cd LibrariesApiTest/HackerRank1
dotnet restore
dotnet run
```

API disponible en `http://localhost:5219` (Swagger en desarrollo).

## Credenciales

- Email: `admin`
- Password: `1234`

## Endpoints de autenticación

### POST `/api/auth/login`

Request:

```json
{
  "email": "admin",
  "password": "1234"
}
```

Response:

```json
{
  "token": "eyJhbG..."
}
```

## Endpoints protegidos

- `GET /api/libraries` requiere `[Authorize(Roles = "admin")]`
- Enviar header: `Authorization: Bearer <token>`

## CORS

Origen permitido por defecto: `http://localhost:5173` (configurable en `appsettings.json` → `Cors:AllowedOrigins`).

## Publicación

### Local

```bash
dotnet publish -c Release -o ./publish
```

### MonsterASP.NET (GitHub Actions)

El workflow `.github/workflows/deploy.yml` publica y despliega automáticamente en cada push a `main`.

**Secrets requeridos en GitHub** (Settings → Secrets and variables → Actions):

| Secret | Ejemplo | Dónde obtenerlo |
|--------|---------|-----------------|
| `WEBSITE_NAME` | `site1234` | Panel MonsterASP → WebDeploy |
| `SERVER_COMPUTER_NAME` | `https://site1234.siteasp.net:8172` | Panel MonsterASP → WebDeploy |
| `SERVER_USERNAME` | `site1234` | Panel MonsterASP → WebDeploy |
| `SERVER_PASSWORD` | `********` | Panel MonsterASP → WebDeploy |

**Después del deploy:**

1. Actualiza `Cors:AllowedOrigins` en `appsettings.Production.json` con la URL real del frontend.
2. Configura el frontend con `VITE_API_URL` apuntando a tu API en MonsterASP (ej. `https://site1234.siteasp.net`).
