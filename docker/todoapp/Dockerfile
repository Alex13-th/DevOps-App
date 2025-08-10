# ---------- Stage 1: Build wheels ----------
ARG PYTHON_VERSION=3.11-slim
FROM python:${PYTHON_VERSION} AS builder

WORKDIR /app

# Системні пакети для збірки mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config default-libmysqlclient-dev build-essential \
 && rm -rf /var/lib/apt/lists/*

# Оновлюємо pip і ставимо залежності у вигляді wheel
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

COPY . .
RUN chmod +x entrypoint.sh


# ---------- Stage 2: Runtime ----------
FROM python:${PYTHON_VERSION} AS run

WORKDIR /app
ENV PYTHONUNBUFFERED=1

# Тільки runtime-бібліотека для mysqlclient
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmariadb3 \
 && rm -rf /var/lib/apt/lists/*

# Копіюємо wheels і встановлюємо
COPY --from=builder /wheels /wheels
RUN pip install --no-cache /wheels/*

# Копіюємо код
COPY --from=builder /app .

EXPOSE 8080
ENTRYPOINT ["sh", "./entrypoint.sh"]
