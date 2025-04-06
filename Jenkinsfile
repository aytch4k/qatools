pipeline {
    agent {
        docker {
            image 'my-test-runner:latest'
            args '-v ${WORKSPACE}/tests:/app/tests -v ${WORKSPACE}/results:/app/results'
        }
    }
    stages {
        stage('Setup') {
            steps {
                sh 'ganache --port 8545 --quiet & sleep 5'
            }
        }
        stage('Run Tests') {
            parallel {
                stage('Blockchain Tests') {
                    steps {
                        sh 'pytest /app/tests/blockchain_tests.py --alluredir=/app/results/allure'
                    }
                }
                stage('UI Tests (Web)') {
                    steps {
                        sh 'pytest /app/tests/web_tests.py --alluredir=/app/results/allure'
                    }
                }
                stage('UI Tests (iOS)') {
                    steps {
                        sh 'pytest /app/tests/ios_tests.py --alluredir=/app/results/allure'
                    }
                }
                stage('Performance Tests') {
                    steps {
                        sh 'jmeter -n -t /app/tests/load_test.jmx -l /app/results/jmeter_results.jtl'
                        sh 'k6 run /app/tests/load_test.js'
                    }
                }
            }
        }
        stage('Generate Reports') {
            steps {
                sh 'allure generate /app/results/allure -o /app/results/allure-report --clean'
            }
        }
        stage('Code Quality') {
            steps {
                sh 'sonar-scanner -Dsonar.projectKey=my_project -Dsonar.sources=/app/tests -Dsonar.host.url=http://sonarqube:9001 -Dsonar.login=${SONAR_TOKEN}'
            }
        }
    }
    post {
        always {
            archiveArtifacts 'results/*'
            allure includeProperties: false, jdk: '', results: [[path: 'results/allure']]
        }
    }
}