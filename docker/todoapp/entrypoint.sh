#!/usr/bin/env sh
set -eu

export DJANGO_SETTINGS_MODULE="todolist.settings"
export PYTHONPATH="/app"

echo "⏳ Waiting for DB (via Django)..."
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

echo "🔧 Running migrations..."
python manage.py migrate --noinput

echo "🚀 Starting server..."
exec python manage.py runserver 0.0.0.0:8080


