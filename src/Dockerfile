# ---------- Stage 1: build wheels ----------
ARG PYTHON_VERSION=3.11-slim
FROM python:${PYTHON_VERSION} AS builder

WORKDIR /app

# системні залежності для збірки mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc build-essential pkg-config default-libmysqlclient-dev \
 && rm -rf /var/lib/apt/lists/*

# спочатку тільки requirements.txt, щоб кешувати
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# потім код (не критично, але зручно мати на стадії build)
COPY . .

# ---------- Stage 2: runtime ----------
FROM python:${PYTHON_VERSION} AS run

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# легкі рантайм-ліби для mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmariadb3 \
 && rm -rf /var/lib/apt/lists/*

# ставимо зібрані колеса
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/* && rm -rf /wheels

# код + entrypoint
COPY . .
RUN chmod +x /app/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]

