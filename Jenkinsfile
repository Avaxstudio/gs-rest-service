pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_CONTAINER = 'test-app'
        HOST_PORT = '777'
        CONTAINER_PORT = '8080'
        SLACK_WEBHOOK = credentials('gs-rest-slack-hook')
    }

    stages {
        stage('Notify Start') {
            steps {
                sh """
                    curl -X POST -H 'Content-type: application/json' \\
                    --data '{"text": ":rocket: Build started for *${env.JOB_NAME}* (#${env.BUILD_NUMBER})"}' \\
                    "${env.SLACK_WEBHOOK}"
                """
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                dir('complete') {
                    sh 'mvn -B test | tee mvn-test.log'
                }
            }
        }

        stage('Notify Test Results') {
            steps {
                script {
                    def summary = sh(
                        script: "cd complete && grep -E 'Tests run:|Failures:|Errors:|Skipped:' mvn-test.log || echo 'No test summary found'",
                        returnStdout: true
                    ).trim()

                    def escaped = summary.replace('\"', '\\\"').replace('\n', '\\n')

                    sh """
                        curl -X POST -H 'Content-type: application/json' \\
                        --data '{"text": ":bar_chart: *Test results for* ${env.JOB_NAME} (#${env.BUILD_NUMBER}):\\n${escaped}"}' \\
                        "${env.SLACK_WEBHOOK}"
                    """
                }
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

        success {
            sh """
                curl -X POST -H 'Content-type: application/json' \\
                --data '{"text": ":white_check_mark: Build succeeded for *${env.JOB_NAME}* (#${env.BUILD_NUMBER})"}' \\
                "${env.SLACK_WEBHOOK}"
            """
        }
        failure {
            sh """
                curl -X POST -H 'Content-type: application/json' \\
                --data '{"text": ":x: Build FAILED for *${env.JOB_NAME}* (#${env.BUILD_NUMBER})"}' \\
                "${env.SLACK_WEBHOOK}"
            """
        }
    }
}
