# 🛡️ Cheicon Backend - API REST con Flask y MongoDB

Cheicon Backend es una API REST construida con **Flask**, **MongoDB Atlas** y **JWT**.  
Expone los endpoints que consume la app móvil de Cheicon para manejar **usuarios**, **posts**, **likes** y **comentarios**, con autenticación basada en tokens.

---

## ✨ Características principales

### 🔐 Autenticación y seguridad
- Registro e inicio de sesión de usuarios con email y contraseña  
- Hash de contraseñas con **Flask-Bcrypt**  
- Generación de tokens de acceso con **Flask-JWT-Extended**  
- Endpoints protegidos con `@jwt_required()`  
- Endpoint `/usuarios/me` para obtener los datos del usuario autenticado  

### 👤 Gestión de usuarios
- Crear cuenta nueva (`/usuarios/createAccount`)  
- Login (`/usuarios/login`)  
- Obtener perfil público por `username` (`/usuarios/<username>`)  
- Obtener perfil propio (`/usuarios/me`)  
- Actualizar perfil propio (`/usuarios/me/update`)  
- Eliminar usuario y sus posts (`DELETE /usuarios/<username>`)  

### 📝 Gestión de posts
- Crear post con:
  - título  
  - descripción  
  - `img_url` (URL generada en Cloudinary desde el frontend)  
- Listar todos los posts (`GET /posts/`)  
- Obtener un post por id (`GET /posts/<post_id>`)  
- Editar título y descripción de un post propio  
- Borrar posts propios  
- Sistema de likes:
  - contador de likes  
  - lista de usuarios que han dado like (`liked_by`)  
  - endpoints para like y unlike  

### 💬 Comentarios
- Agregar comentarios a un post (`POST /comments/<post_id>/comment`)  
- Listar comentarios de un post (`GET /comments/<post_id>/comments`)  
- Eliminar comentarios propios (`DELETE /comments/<post_id>/comment/<comment_id>`)  

---

## 🛠️ Tecnologías utilizadas

### Core
- **Python 3**  
- **Flask** como framework web  
- **MongoDB Atlas** como base de datos principal  
- **PyMongo** para la conexión con MongoDB  
- **python-dotenv** para cargar variables de entorno  

### Autenticación y seguridad
- **Flask-JWT-Extended** para manejo de JWT  
- **Flask-Bcrypt** para hash de contraseñas  

### Otras dependencias clave
- `pymongo`  
- `dnspython`  
- `Werkzeug`  
- `Jinja2`  
- `click`  

---

## 📂 Estructura del proyecto

PDM_backend/
├─ app.py
├─ config/
│  └─ db.py              # init_db, conexión a MongoDB y configuración base de Flask
├─ routes/
│  ├─ usuarios.py        # endpoints de usuarios (auth, perfil)
│  ├─ posts.py           # endpoints de posts y likes
│  └─ comments.py        # endpoints de comentarios
├─ requirements.txt
├─ .env                  # variables de entorno (no se sube al repo)
└─ ...

- `app.py`  
  - Crea la instancia de Flask  
  - Inicializa la base de datos con `init_db(app)`  
  - Configura `JWTManager` con `JWT_SECRET_KEY`  
  - Registra los blueprints de `usuarios`, `posts` y `comments`  

- `config/db.py`  
  - Lee variables de entorno con `dotenv`  
  - Crea el cliente de MongoDB y adjunta `app.db` para usarlo en los blueprints  

- `routes/usuarios.py`, `routes/posts.py`, `routes/comments.py`  
  - Definen los endpoints y la lógica de negocio de la API  

---

## ⚙️ Configuración

### 1. Variables de entorno (.env)

Crea un archivo `.env` en la raíz del proyecto con algo como:

MONGO_URI="TU_CADENA_DE_CONEXION_DE_MONGODB"
MONGO_DB_NAME="Cheicon"
SECRET_KEY="tu_secret_key_flask"
JWT_SECRET_KEY="tu_secret_key_jwt"
FLASK_DEBUG=1

Importante: no subas tu `.env` al repositorio.

### 2. Instalación de dependencias

Crea y activa un entorno virtual y después:

pip install -r requirements.txt

---

## ▶️ Cómo correr el proyecto en local

1. Clonar el repositorio del backend  
2. Crear el archivo `.env` con tus credenciales de MongoDB y llaves secretas  
3. Instalar dependencias:

   pip install -r requirements.txt

4. Ejecutar la app:

   python app.py

Por defecto corre en `http://0.0.0.0:8080` o en el puerto definido en la variable de entorno `PORT`.

---

## 🌐 Endpoints principales

Todos los endpoints marcados con 🔒 requieren enviar el token JWT en el header:  

Authorization: Bearer TU_TOKEN

### 👤 Usuarios (/usuarios)

- GET /usuarios/  
  Devuelve la lista de usuarios (sin contraseñas).

- POST /usuarios/createAccount  
  Crea un nuevo usuario.  
  Body JSON de ejemplo:

  {
    "username": "alex",
    "email": "correo@example.com",
    "password": "123456",
    "nombre": "Nombre opcional",
    "biografia": "Bio opcional",
    "avatar_url": "https://..."
  }

- POST /usuarios/login  
  Devuelve `usuario` y `access_token` si las credenciales son correctas.

- GET /usuarios/me 🔒  
  Devuelve los datos del usuario autenticado.

- PATCH /usuarios/me/update 🔒  
  Actualiza `nombre`, `biografia` y/o `avatar_url` del usuario autenticado.

- GET /usuarios/<username>  
  Devuelve la info pública del usuario y sus posts.

- DELETE /usuarios/<username> 🔒  
  Elimina un usuario (solo puede hacerlo el dueño) y sus posts.

---

### 📝 Posts (/posts)

- GET /posts/  
  Devuelve todos los posts.

- GET /posts/<post_id>  
  Devuelve un post por id.

- POST /posts/ 🔒  
  Crea un post nuevo.  
  Body JSON de ejemplo:

  {
    "title": "Título del post",
    "description": "Descripción opcional",
    "img_url": "https://url-de-cloudinary.com/imagen.jpg"
  }

- PATCH /posts/<post_id> 🔒  
  Actualiza título y descripción del post si el usuario autenticado es el dueño.

- DELETE /posts/<post_id> 🔒  
  Elimina un post propio.

- POST /posts/<post_id>/like 🔒  
  Da like a un post, incrementa `likes` y agrega el username a `liked_by`.

- POST /posts/<post_id>/unlike 🔒  
  Quita el like del post, decrementa `likes` y remueve el username de `liked_by`.

---

### 💬 Comentarios (/comments)

- POST /comments/<post_id>/comment 🔒  
  Agrega un comentario a un post.

- GET /comments/<post_id>/comments  
  Devuelve la lista de comentarios de un post.

- DELETE /comments/<post_id>/comment/<comment_id> 🔒  
  Permite borrar un comentario si el autor es el usuario autenticado.

---

## 🔄 Flujo de autenticación con la app móvil

1. El frontend envía email y contraseña a `POST /usuarios/login`.  
2. El backend valida las credenciales, genera un `access_token` JWT e incluye datos del usuario.  
3. La app guarda ese token en AsyncStorage y en Zustand.  
4. Para cada request protegida, la app envía el header `Authorization: Bearer <token>`.  
5. Los decoradores `@jwt_required()` leen el token, obtienen el `username` con `get_jwt_identity()` y permiten o bloquean el acceso según corresponda.

---
