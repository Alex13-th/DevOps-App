# Django-Python App

Simple web application demonstrating common features: user accounts/login, REST API, and a basic interactive UI.

## 🚀 Get Started

### 1. Create a virtual environment and install dependencies
```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
```
### 2. Running Docker Compose in detached mode

```bash
cd src/
docker compose up -d
```

### 3. Verify the app is running locally

Open your browser and navigate to:

```arduino
http://localhost:8080/
```


### Shutdown the app

```bash
cd src/
docker compose down
```

# Project Overview

## 🎯 Objective
Demonstrate DevOps practices on an existing Python/Django application by implementing a full containerization and CI/CD pipeline.

## 🛠 What I Implemented
1. **Dockerfile** — production-ready Python 3.11 image:
   - multi-stage build;
   - optimized dependency installation with caching;
   - supports running via gunicorn + whitenoise.
2. **Docker Compose** — for local development:
   - application service;
   - MySQL database;
   - environment configurable via `.env`.
3. **CI/CD (GitHub Actions)**:
   - Triggered on the `develop` branch when changes occur in `src/**` or workflow files.
   - **Linting**: flake8, black, isort.
   - **Testing**: pytest + pytest-django.
   - **Build & Scan**: build image with `sha-${GITHUB_SHA}` tag + Trivy scan (CRITICAL vulnerabilities).
   - **Push**: automatically push image to GitHub Container Registry (`ghcr.io/alex13-th/devops-app`).
   - pip and buildx caching for faster builds.
   - Concurrency control to cancel previous in-progress jobs for the same branch.
4. **Image Versioning**:
   - tagging images with commit SHA;
   - ready for integration with Helm/ArgoCD for automated deployments.

## 📈 Outcome
The result is a reproducible, tested image ready for deployment to Kubernetes via Helm, ensuring consistent behavior across local, CI, and production environments.

## 🔜 Next Steps
- Create `deploy-<project>` repository with Helm chart for deployments.
- Integrate with ArgoCD or Helm-based CD pipeline.
- Define infrastructure with Terraform.