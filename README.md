# 🚀 Flask App Deployment with Helm & Kubernetes

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
└── README.md               # This file
```


![Helm Deployment](https://raw.githubusercontent.com/yairk-create/flask-helm-deploy/main/docs/images.png)


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

- Deploys to namespace `flask`
- Exposes the app via `NodePort` (default: `30080`)
- Image and tag managed via `values.yaml`

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

After deployment, open:

```
http://<your-node-ip>:30080
```

Or port-forward (if using ClusterIP):

```bash
kubectl port-forward -n flask svc/flask-app 5000:80
```



## 🛠️ Prerequisites

- Docker
- Kubernetes cluster (e.g., K3s, Minikube)
- Helm v3+
- Docker Hub account

---

## 📄 License

MIT License — feel free to use and adapt.

---

## 🤝 Contributing

1. Fork this repo
2. Create a new branch (`git checkout -b feature-name`)
3. Commit your changes
4. Push and create a Pull Request

---

## 🔗 Credits

Built by Yair Kochavi using open-source tools.
