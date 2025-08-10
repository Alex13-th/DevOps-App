#!/usr/bin/env sh
set -eu

echo "⏳ Waiting for DB (via Django)..."
python - <<'PY'
import time, sys, django
from django.db import connections
from django.db.utils import OperationalError
django.setup()
for _ in range(60):
    try:
        connections['default'].cursor()
        sys.exit(0)
    except OperationalError:
        time.sleep(1)
sys.exit(1)
PY

echo "🔧 Running migrations..."
python manage.py migrate --noinput

echo "🚀 Starting server..."
exec python manage.py runserver 0.0.0.0:8080
