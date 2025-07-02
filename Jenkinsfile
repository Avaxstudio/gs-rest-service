pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_CONTAINER = 'test-app'
        HOST_PORT = '777'
        CONTAINER_PORT = '8080'
        ENDPOINT = "http://localhost:${HOST_PORT}/greeting"
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Clean Workspace & Checkout') {
            steps {
                deleteDir()
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${APP_IMAGE} ."
            }
        }

        stage('Run Application') {
            steps {
                echo 'Removing previous container if it exists...'
                sh "docker rm -f ${APP_CONTAINER} || true"

                echo 'Running container...'
                sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${APP_CONTAINER} ${APP_IMAGE}"
            }
        }

        stage('Inspect Container Logs') {
            steps {
                echo 'Inspecting logs from Docker container...'
                sh "sleep 1 && docker logs ${APP_CONTAINER} || true"
            }
        }

        stage('Wait for App to Respond (From Inside Container)') {
            steps {
                echo 'Checking /greeting endpoint directly inside container...'
                sh '''
                    for i in $(seq 1 12); do
                      if docker exec test-app curl -fs http://localhost:8080/greeting > /dev/null; then
                        echo "App responded successfully from inside container."
                        exit 0
                      fi
                      echo "Attempt $i: not responding yet."
                      sleep 2
                    done
                    echo "Application failed to respond from inside container."
                    exit 1
                '''
            }
        }

        stage('Test Endpoint (Host-side)') {
            steps {
                echo 'Testing application endpoint from host (optional)...'
                sh 'curl -f $ENDPOINT || true'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up container...'
            sh "docker rm -f ${APP_CONTAINER} || true"
        }
        success {
            echo 'Build completed successfully.'
        }
        failure {
            echo 'Build failed. Check logs for details.'
        }
    }
}
