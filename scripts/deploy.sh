#!/usr/bin/env bash
###########################
# Written by: Yair Kochavi
# Date: 27/07/2025
# Purpose: Build Flask Docker image, update Helm chart, and deploy to Kubernetes namespace "flask".
# License: MIT
# Usage: ./deploy.sh
# Dependencies: docker, helm
# Requirements: Debian-based system
# Version: 0.0.6
###########################

set -e

# Check OS
if ! grep -qiE "debian|ubuntu" /etc/os-release; then
  printf "\033[0;31mError: This script only supports Debian/Ubuntu systems.\033[0m\n"
  exit 1
fi

# Check root
if [ "$EUID" -ne 0 ]; then
  printf "Not running as root. Trying to run with sudo...\n"
  exec sudo "$0" "$@"
fi

APP_NAME=flask-app
NAMESPACE=flask

read -p "Enter your Docker Hub username: " DOCKER_USER
read -s -p "Enter your Docker Hub access token: " DOCKER_TOKEN
echo ""

IMAGE="$DOCKER_USER/$APP_NAME:latest"

echo "🔐 Logging in to Docker Hub..."
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin

echo "⏳ Building Docker image: $IMAGE"
docker build -t $IMAGE .

echo "📤 Pushing Docker image to Docker Hub"
docker push $IMAGE

echo "📝 Updating values.yaml with image: $IMAGE"
sed -i "s|repository:.*|repository: $DOCKER_USER/$APP_NAME|" helm/$APP_NAME/values.yaml
sed -i "s|tag:.*|tag: \"latest\"|" helm/$APP_NAME/values.yaml

echo "🚀 Deploying to namespace '$NAMESPACE' with Helm"
helm upgrade --install $APP_NAME ./helm/$APP_NAME \
  --namespace $NAMESPACE \
  --create-namespace \
  --set image.repository=$DOCKER_USER/$APP_NAME

printf "\033[0;32m\n✅ Deployment complete\n\033[0m"
printf "\033[0;32m📦 Namespace: %s\n\033[0m" "$NAMESPACE"
printf "\033[0;32m🌐 Access your app using port-forward or Ingress (if configured)\n\033[0m"
printf "\033[0;32m🔗 Docker Image: %s\n\n\033[0m" "$IMAGE"
printf "\033[0;32m✅ Deployment complete!\n\033[0m"
printf "\033[0;32mTo access the Flask app from this host, run:\n\033[0m"
printf "\033[0;32m  kubectl port-forward -n flask svc/flask-app 5000:80\n\033[0m"
printf "\033[0;32mThen open another terminal and visit or curl:\n\033[0m"
printf "To reach the app, run:\n"
printf "\033[0;34m%s\033[0m\n" "curl http://localhost:5000"
