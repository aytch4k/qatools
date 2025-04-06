#!/bin/bash

# Make script executable
chmod +x "$0"

# Set working directory
cd "$(dirname "$0")"

echo "Checking QA tools status..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "Error: Docker is not running. Please start Docker and try again."
  exit 1
fi

# Check if containers are running
echo "Checking container status..."
CONTAINERS=(
  "devops-jenkins"
  "qa-sonarqube"
  "db-postgres-15"
  "qa-selenium-grid-hub"
  "qa-selenium-chrome-node"
  "qa-ganache"
  "blockchain-node-cosmos"
  "blockchain-node-polkadot"
  "blockchain-node-algorand"
  "qa-appium"
)

ALL_RUNNING=true
for CONTAINER in "${CONTAINERS[@]}"; do
  STATUS=$(docker ps -q -f name=$CONTAINER)
  if [ -z "$STATUS" ]; then
    echo "❌ $CONTAINER is not running"
    ALL_RUNNING=false
  else
    echo "✅ $CONTAINER is running"
  fi
done

if [ "$ALL_RUNNING" = false ]; then
  echo "Some containers are not running. Please check the logs with 'docker logs <container-name>'"
  exit 1
fi

# Check if Jenkins is accessible
echo -e "\nChecking Jenkins..."
JENKINS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081)
if [ "$JENKINS_STATUS" -eq 200 ] || [ "$JENKINS_STATUS" -eq 403 ]; then
  echo "✅ Jenkins is accessible (HTTP $JENKINS_STATUS)"
else
  echo "❌ Jenkins is not accessible (HTTP $JENKINS_STATUS)"
fi

# Check if SonarQube is accessible
echo -e "\nChecking SonarQube..."
SONAR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9001)
if [ "$SONAR_STATUS" -eq 200 ]; then
  echo "✅ SonarQube is accessible (HTTP $SONAR_STATUS)"
else
  echo "❌ SonarQube is not accessible (HTTP $SONAR_STATUS)"
fi

# Check if Selenium Grid is accessible
echo -e "\nChecking Selenium Grid..."
SELENIUM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:4444)
if [ "$SELENIUM_STATUS" -eq 200 ]; then
  echo "✅ Selenium Grid is accessible (HTTP $SELENIUM_STATUS)"
else
  echo "❌ Selenium Grid is not accessible (HTTP $SELENIUM_STATUS)"
fi

# Check if Ganache is accessible
echo -e "\nChecking Ganache..."
GANACHE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545)
if [ "$GANACHE_STATUS" -eq 200 ]; then
  echo "✅ Ganache is accessible (HTTP $GANACHE_STATUS)"
else
  echo "❌ Ganache is not accessible (HTTP $GANACHE_STATUS)"
fi

echo -e "\nAll checks completed. If any service is not accessible, please check the logs with 'docker logs <container-name>'"
echo "To run a test pipeline in Jenkins, go to http://localhost:8080 and create a new pipeline using the Jenkinsfile in this repository."