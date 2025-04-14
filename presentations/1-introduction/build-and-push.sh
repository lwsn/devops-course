#!/bin/bash
set -e

# Configuration
APP_NAME="k8s-intro-presentation"
AWS_REGION="eu-north-1"
AWS_PROFILE="kumpan-devops"
IMAGE_TAG="latest"
AWS_ACCOUNT_ID="289831833738"

# ECR repository URI
ECR_REPOSITORY="presentations/introduction"
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"

# Login to ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $ECR_URI

# Build the Docker image
echo "Building Docker image..."
docker build -t ${APP_NAME}:${IMAGE_TAG} .

# Tag the image for ECR
echo "Tagging image for ECR..."
docker tag ${APP_NAME}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}

# Push the image to ECR
echo "Pushing image to ECR..."
docker push ${ECR_URI}:${IMAGE_TAG}

echo "Done! Image pushed to ${ECR_URI}:${IMAGE_TAG}"
echo "You can now use this image to serve the presentation."
