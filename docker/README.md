# Quality Assurance Platform

A comprehensive Docker-based QA platform with tools for testing blockchain applications, web UIs, mobile apps, and more.

## Components

- **Jenkins**: CI/CD server for running automated test pipelines
- **SonarQube**: Code quality and security analysis
- **Selenium Grid**: Browser automation for web UI testing
- **Appium**: Mobile app testing
- **Blockchain Nodes**:
  - Ganache (Ethereum)
  - Cosmos
  - Polkadot
  - Algorand
- **Test Runner**: Custom container with all testing tools pre-installed

## Getting Started

### Prerequisites

- Docker and Docker Compose
- At least 8GB of RAM available for Docker
- At least 20GB of free disk space

### Installation

1. Clone this repository
2. Run the launch script:

**On Linux/macOS:**
```bash
./launch-qa-tools.sh
```

**On Windows:**
```cmd
launch-qa-tools.bat
```

3. Wait for all services to start (this may take a few minutes)
4. Check if all services are running:

**On Linux/macOS:**
```bash
./check-qa-tools.sh
```

**On Windows:**
```cmd
check-qa-tools.bat
```

### Accessing the Tools

- **Jenkins**: http://localhost:8081
- **SonarQube**: http://localhost:9001 (default credentials: admin/admin)
- **Selenium Grid**: http://localhost:4444
- **Ganache**: http://localhost:8545
- **Cosmos Node**: http://localhost:26657
- **Polkadot Node**: http://localhost:9944
- **Algorand Node**: http://localhost:4001
- **Appium**: http://localhost:4723

## Running Tests

### Using Jenkins

1. Go to Jenkins at http://localhost:8080
2. Create a new Pipeline job
3. Configure the Pipeline to use the Jenkinsfile from this repository
4. Run the pipeline

### Manually

You can run tests directly using the test-runner container:

```bash
docker exec -it qa-test-runner pytest /app/tests/blockchain_tests.py
```

## Configuration

### Environment Variables

Environment variables are stored in the `.env` file in the docker directory. You can modify this file to change configuration options.

Important variables:

- `SONAR_TOKEN`: Token for SonarQube authentication
- `POSTGRES_USER`, `POSTGRES_PASSWORD`: Database credentials for SonarQube

### Jenkins Plugins

Jenkins plugins are listed in the `jenkins-plugins.txt` file. You can add or remove plugins by modifying this file and restarting Jenkins.

## Troubleshooting

If you encounter issues:

1. Check container logs:

```bash
docker logs devops-jenkins
```

2. Ensure all containers are running:

```bash
docker ps
```

3. Restart a specific service:

```bash
docker-compose restart jenkins
```

4. Restart all services:

```bash
docker-compose down
docker-compose up -d
```

## Extending the Platform

### Adding New Test Types

1. Add test files to the `tests` directory
2. Update the Jenkinsfile to include the new tests
3. Rebuild and restart the containers

### Adding New Tools

1. Modify the Dockerfile to install additional tools
2. Update the docker-compose.yml file if needed
3. Rebuild the images:

```bash
docker-compose build
