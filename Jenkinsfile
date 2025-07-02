pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_CONTAINER = 'test-app'
        HOST_PORT = '777'
        CONTAINER_PORT = '8080'
        SLACK_WEBHOOK = credentials('https://hooks.slack.com/services/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')
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
            sh """
                curl -X POST -H 'Content-type: application/json' \
                --data '{"text": ":x: *Build failed* for gs-rest-service"}' \
                "$SLACK_WEBHOOK"
            """
        }
        always {
            sh "docker rm -f ${APP_CONTAINER} || true"
        }
    }
}
