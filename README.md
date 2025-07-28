# Flask Helm Deployment

This project demonstrates how to deploy a Flask app to Kubernetes using Helm and Docker.

## Features

- Flask app containerized with Gunicorn
- Helm chart for Kubernetes deployment
- One-click deploy with `scripts/deploy.sh`

## Quickstart

1. Set your Docker Hub username in `scripts/deploy.sh`
2. Run the script:

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

## License

MIT License
