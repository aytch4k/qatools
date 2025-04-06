#!/bin/bash

# Make script executable
chmod +x "$0"

# Set working directory
cd "$(dirname "$0")"

echo "Building and launching QA tools..."

# Copy test files if they don't exist
if [ ! -d "tests" ]; then
  mkdir -p tests
fi

if [ ! -d "results" ]; then
  mkdir -p results
fi

# Build and start the containers
cd docker
docker-compose --env-file .env build
docker-compose --env-file .env up -d

echo "QA tools are starting up..."
echo "Jenkins will be available at: http://localhost:8081"
echo "SonarQube will be available at: http://localhost:9001"
echo ""
echo "Wait a few minutes for all services to initialize."
echo "Default SonarQube credentials: admin/admin"
echo ""
echo "To stop the services, run: docker-compose down"