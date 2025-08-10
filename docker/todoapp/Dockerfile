# ---------- Stage 1: build wheels ----------
ARG PYTHON_VERSION=3.11-slim
FROM python:${PYTHON_VERSION} AS builder

WORKDIR /opt/build

# deps для збірки mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config default-libmysqlclient-dev build-essential \
 && rm -rf /var/lib/apt/lists/*

# інсталюємо залежності у вигляді wheel
COPY docker/todoapp/requirements.txt .
RUN pip install --upgrade pip && \
    pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt


# ---------- Stage 2: runtime ----------
FROM python:${PYTHON_VERSION} AS run

# лише runtime-бібліотека для mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmariadb3 \
 && rm -rf /var/lib/apt/lists/*

# ставимо зібрані колеса
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/* && rm -rf /wheels

# entrypoint кладемо поза /app, щоб volume його не перекривав
COPY docker/todoapp/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# робоча директорія для коду (буде змонтована з хоста)
WORKDIR /app
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]

