# ============================================
# Stage 1: Builder - Instalación de dependencias
# ============================================
FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar dependencias del sistema necesarias para compilar paquetes Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements y instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ============================================
# Stage 2: Runtime - Imagen final optimizada
# ============================================
FROM python:3.11-slim AS runtime

WORKDIR /app

# Copiar solo las dependencias instaladas desde el builder
COPY --from=builder /root/.local /root/.local

# Asegurar que los scripts estén en el PATH
ENV PATH=/root/.local/bin:$PATH

# Copiar solo el código de la aplicación
COPY app/ app/

# Exponer el puerto
EXPOSE 8000

# Comando por defecto
CMD ["python", "app/main.py"]
