@echo off
echo Building and launching QA tools...

REM Set working directory
cd %~dp0

REM Create directories if they don't exist
if not exist tests mkdir tests
if not exist results mkdir results

REM Build and start the containers
cd docker
docker-compose --env-file .env build
docker-compose --env-file .env up -d

echo QA tools are starting up...
echo Jenkins will be available at: http://localhost:8081
echo SonarQube will be available at: http://localhost:9001
echo.
echo Wait a few minutes for all services to initialize.
echo Default SonarQube credentials: admin/admin
echo.
echo To stop the services, run: docker-compose down