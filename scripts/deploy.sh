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

echo "✅ Deployment complete"
echo "📦 Namespace: $NAMESPACE"
echo "🌐 Access your app using port-forward or Ingress (if configured)"
echo "🔗 Docker Image: $IMAGE"