<p align="center">
  <img src="https://raw.githubusercontent.com/yairk-create/flask-helm-deploy/main/docs/images.png" width="200" alt="Helm Logo">
</p>

<h1 align="center"> Flask App Deployment with Helm & Kubernetes</h1>

<p align="center">
  <b>Deploy a Flask app to Kubernetes using Docker and Helm</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/docker-ready-blue" />
  <img src="https://img.shields.io/badge/helm-chart-blueviolet" />
  <img src="https://img.shields.io/badge/license-MIT-green" />
</p>

---

This project demonstrates how to package and deploy a simple Flask web app using Docker, Helm, and Kubernetes. It supports NFS volume mounting, namespace isolation, and NodePort service exposure.

---

## 📁 Project Structure

```
flask-helm/
├── app/                    # Flask application code
│   ├── main.py             # Main entry point for Flask
│   └── requirements.txt    # Python dependencies
├── Dockerfile              # Container definition
├── helm/
│   └── flask-app/          # Helm chart
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           └── service.yaml
├── scripts/
│   └── deploy.sh           # One-click build and deploy script
├── .gitignore
├── LICENSE
├── docs/
│ └── image.png # pic
└── README.md # This file
```

---

## 🐍 Flask App (`main.py`)

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello from Flask with Helm!"
```

---

## 📦 Dockerfile

```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY app /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "main:app"]
```

---

## 🎯 Helm Chart Highlights

- Deploys the app to Kubernetes namespace flask

- Exposes the app via ClusterIP service (internal access only, no external port open)

- Service listens on port 80 inside the cluster and routes to container port 8000

- Docker image repository and tag are managed via values.yaml
---

## 🧠 Deployment Script

The `deploy.sh` script:
- Prompts for Docker Hub username + token
- Builds & pushes the Docker image
- Updates the Helm chart with your image
- Installs or upgrades the app in Kubernetes

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

---

## 🌐 Access the App

```bash
curl http://localhost:5000  
# → Hello from Flask with Helm!
```

---

## 🛠️ Prerequisites
-Kubernetes cluster (version 1.19 or later)
- Docker
- Kubernetes cluster (e.g., K3s, Minikube)
- Helm v3+
- A GitHub Personal Access Token with read & write:packages scope for accessing the chart from GitHub Container Registry
- This deploy script is tested only on Debian-based systems
- The script must be run with sudo/root permissions

---

## 📄 License

MIT License — feel free to use and adapt.

---

---

## 🔗 Credits

Built by Yair Kochavi using open-source tools.
