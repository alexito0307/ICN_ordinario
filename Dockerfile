FROM python:3.11-slim

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Dependencias del sistema (útil si usas mysqlclient u otras libs nativas)
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copiar dependencias de Python
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el proyecto
COPY . .

# Puerto interno donde escuchará la app Flask
ENV PORT=8000
EXPOSE 8000

# Arrancar la app con Gunicorn
# Formato: archivo_python:variable_app
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
