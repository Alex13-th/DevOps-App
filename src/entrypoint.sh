#!/usr/bin/env sh
set -eu

# де лежить код усередині контейнера
export PYTHONPATH="/app"
export DJANGO_SETTINGS_MODULE="todolist.settings"

ENGINE="${ENGINE:-${DB_ENGINE:-}}"

if [ "$ENGINE" = "django.db.backends.mysql" ]; then
  echo "⏳ Waiting for MySQL via Django connection..."
  python - <<'PY'
import os, time, sys, django
from django.db import connections
from django.db.utils import OperationalError

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "todolist.settings")
django.setup()

deadline = time.time() + 60
while time.time() < deadline:
    try:
        connections["default"].cursor()
        sys.exit(0)
    except OperationalError:
        time.sleep(1)

print("DB is not ready after 60s", file=sys.stderr)
sys.exit(1)
PY
else
  echo "ℹ️ ENGINE is not MySQL (likely SQLite). Skipping DB wait."
fi

echo "🔧 Running migrations..."
python manage.py migrate --noinput

echo "📦 Collecting static..."
python manage.py collectstatic --noinput

echo "🚀 Starting Gunicorn..."
exec gunicorn todolist.wsgi:application --bind 0.0.0.0:8080 --workers 3

