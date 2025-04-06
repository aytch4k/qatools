@echo off
echo Checking QA tools status...

REM Set working directory
cd %~dp0

REM Check if Docker is running
docker info > nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo Error: Docker is not running. Please start Docker and try again.
  exit /b 1
)

REM Check if containers are running
echo Checking container status...
set CONTAINERS=devops-jenkins qa-sonarqube db-postgres-15 qa-selenium-grid-hub qa-selenium-chrome-node qa-ganache blockchain-node-cosmos blockchain-node-polkadot blockchain-node-algorand qa-appium

set ALL_RUNNING=true
for %%C in (%CONTAINERS%) do (
  docker ps -q -f name=%%C > nul 2>&1
  if %ERRORLEVEL% neq 0 (
    echo ❌ %%C is not running
    set ALL_RUNNING=false
  ) else (
    echo ✅ %%C is running
  )
)

if "%ALL_RUNNING%"=="false" (
  echo Some containers are not running. Please check the logs with 'docker logs ^<container-name^>'
  exit /b 1
)

REM Check if Jenkins is accessible
echo.
echo Checking Jenkins...
curl -s -o nul -w "%%{http_code}" http://localhost:8081 > temp.txt
set /p JENKINS_STATUS=<temp.txt
del temp.txt
if "%JENKINS_STATUS%"=="200" (
  echo ✅ Jenkins is accessible (HTTP %JENKINS_STATUS%)
) else if "%JENKINS_STATUS%"=="403" (
  echo ✅ Jenkins is accessible (HTTP %JENKINS_STATUS%)
) else (
  echo ❌ Jenkins is not accessible (HTTP %JENKINS_STATUS%)
)

REM Check if SonarQube is accessible
echo.
echo Checking SonarQube...
curl -s -o nul -w "%%{http_code}" http://localhost:9001 > temp.txt
set /p SONAR_STATUS=<temp.txt
del temp.txt
if "%SONAR_STATUS%"=="200" (
  echo ✅ SonarQube is accessible (HTTP %SONAR_STATUS%)
) else (
  echo ❌ SonarQube is not accessible (HTTP %SONAR_STATUS%)
)

REM Check if Selenium Grid is accessible
echo.
echo Checking Selenium Grid...
curl -s -o nul -w "%%{http_code}" http://localhost:4444 > temp.txt
set /p SELENIUM_STATUS=<temp.txt
del temp.txt
if "%SELENIUM_STATUS%"=="200" (
  echo ✅ Selenium Grid is accessible (HTTP %SELENIUM_STATUS%)
) else (
  echo ❌ Selenium Grid is not accessible (HTTP %SELENIUM_STATUS%)
)

REM Check if Ganache is accessible
echo.
echo Checking Ganache...
curl -s -o nul -w "%%{http_code}" -X POST -H "Content-Type: application/json" --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}" http://localhost:8545 > temp.txt
set /p GANACHE_STATUS=<temp.txt
del temp.txt
if "%GANACHE_STATUS%"=="200" (
  echo ✅ Ganache is accessible (HTTP %GANACHE_STATUS%)
) else (
  echo ❌ Ganache is not accessible (HTTP %GANACHE_STATUS%)
)

echo.
echo All checks completed. If any service is not accessible, please check the logs with 'docker logs ^<container-name^>'
echo To run a test pipeline in Jenkins, go to http://localhost:8080 and create a new pipeline using the Jenkinsfile in this repository.