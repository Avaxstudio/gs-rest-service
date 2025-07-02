pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_CONTAINER = 'test-app'
        HOST_PORT = '777'
        CONTAINER_PORT = '8080'
        SLACK_WEBHOOK = credentials('gs-rest-slack-hook-v2')

    }

    stages {
        stage('Notify Start') {
            steps {
                sh """
                    curl -X POST -H 'Content-type: application/json' \
                    --data '{"text": ":rocket: *Build started* for gs-rest-service"}' \
                    "$SLACK_WEBHOOK"
                """
            }
        }

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

        stage('Notify Success') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                sh """
                    curl -X POST -H 'Content-type: application/json' \
                    --data '{"text": ":white_check_mark: *Build succeeded* for gs-rest-service"}' \
                    "$SLACK_WEBHOOK"
                """
            }
        }
    }

    post {
        failure {
            script {
                sh """
                    curl -X POST -H 'Content-type: application/json' \
                    --data '{"text": ":x: *Build failed* for gs-rest-service"}' \
                    "$SLACK_WEBHOOK"
                """
            }
        }
        always {
            script {
                sh "docker rm -f ${APP_CONTAINER} || true"
            }
        }
    }
}
