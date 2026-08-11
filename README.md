# ai-legal-chunking

## Auth: Cognito + API Gateway + Lambda (Python) + React

Arquitectura de autenticación (registro, login, confirmación de email, refresh,
logout, forgot/reset password) sobre Amazon Cognito. El frontend en React nunca
habla con Cognito directamente: todo pasa por un HTTP API Gateway respaldado por
Lambdas en Python, que son las únicas que usan el SDK de Cognito.

```
React (frontend/) --HTTP--> API Gateway (HTTP API) --> Lambda (Python) --> Cognito User Pool
```

### Backend (`backend/`)

- `terraform/modules/resources/` — un módulo por recurso de AWS (Cognito, IAM,
  Lambda, API Gateway v2, CloudWatch, etc).
- `terraform/modules/composite/` — módulos que únicamente componen otros
  módulos (`cognito_auth`, `lambda_endpoint`, `auth_api`, `backend_app`).
- `terraform/` (raíz) — el root module que se aplica; llama a `backend_app`.
- `lambdas/` — un directorio por función (`register`, `confirm`,
  `resend_confirmation`, `login`, `refresh`, `forgot_password`,
  `confirm_forgot_password`, `logout`, `me`) más `common/cognito_client.py`
  compartido por todas.

### Frontend (`frontend/`)

Vite + React + TypeScript. Páginas: registro, confirmación de email, login,
forgot/reset password y un dashboard protegido que llama a `/auth/me`.

## Desplegar el backend

El state remoto de Terraform vive en un bucket S3 que **ya debe existir**
(este repo no lo crea). El nombre del bucket se pasa como parámetro al hacer
`init`, nunca queda hardcodeado en el `.tf`.

```bash
cd backend/terraform

cp backend.hcl.example backend.hcl
# editá backend.hcl: bucket = "<tu-bucket-de-state-existente>"
terraform init -backend-config=backend.hcl

cp terraform.tfvars.example terraform.tfvars
# editá terraform.tfvars si hace falta (región, cors_allow_origins, etc)
terraform plan
terraform apply
```

Al terminar, `terraform output api_base_url` te da la URL base que usa el
frontend, y `user_pool_id` / `user_pool_client_id` los IDs del User Pool.

## Correr el frontend

```bash
cd frontend
cp .env.example .env
# editá .env: VITE_API_BASE_URL=<api_base_url del output de terraform>
npm install
npm run dev
```

## Endpoints expuestos

| Método | Ruta                          | Auth | Descripción                          |
|--------|-------------------------------|------|---------------------------------------|
| POST   | `/auth/register`              | No   | Alta de usuario                       |
| POST   | `/auth/confirm`                | No   | Confirma el código enviado por email  |
| POST   | `/auth/resend-confirmation`   | No   | Reenvía el código de confirmación     |
| POST   | `/auth/login`                 | No   | Devuelve id/access/refresh token      |
| POST   | `/auth/refresh`               | No   | Renueva id/access token               |
| POST   | `/auth/forgot-password`       | No   | Envía código de reseteo               |
| POST   | `/auth/confirm-forgot-password` | No | Confirma nueva contraseña             |
| POST   | `/auth/logout`                | No   | Global sign-out (invalida el token)   |
| GET    | `/auth/me`                    | JWT  | Perfil del usuario autenticado        |
