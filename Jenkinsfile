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

       stage('Wait for App to Respond') {
    steps {
        echo 'Waiting for application to become available...'
        sh '''
            for i in $(seq 1 12); do
              if curl -fs http://localhost:777/greeting > /dev/null; then
                echo "Application is responding."
                exit 0
              fi
              echo "Attempt $i: not ready yet."
              sleep 2
            done
            echo "Application failed to respond in time."
            exit 1
        '''
    }
}


        stage('Test Endpoint') {
            steps {
                echo 'Testing application endpoint...'
                sh 'curl -f $ENDPOINT'
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
