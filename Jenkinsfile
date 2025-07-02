pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_CONTAINER = 'test-app'
        HOST_PORT = '777'
        CONTAINER_PORT = '8080'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${APP_IMAGE} ."
            }
        }

        stage('Run Application') {
            steps {
                sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${APP_CONTAINER} ${APP_IMAGE}"
            }
        }
    }

    post {
        always {
            sh "docker rm -f ${APP_CONTAINER} || true"
        }
    }
}
