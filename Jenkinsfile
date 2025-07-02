pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_PORT = '777'
        APP_CONTAINER = 'test-app'
    }

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${APP_IMAGE} ."
            }
        }

        stage('Run Container') {
            steps {
                sh "docker run -d -p ${APP_PORT}:8080 --name ${APP_CONTAINER} ${APP_IMAGE}"
            }
        }

        stage('Wait for App to Start') {
            steps {
                sh '''
                    echo "⏳ Čekam da aplikacija postane dostupna..."

                    for i in {1..10}; do
                      if curl -fs http://localhost:777/greeting > /dev/null; then
                        echo "✅ Aplikacija je spremna!"
                        break
                      fi
                      echo "🔁 Još nije spremna... pokušaj $i"
                      sleep 2
                    done
                '''
            }
        }

        stage('Test Greeting Endpoint') {
            steps {
                sh "curl -f http://localhost:777/greeting"
            }
        }
    }

    post {
        always {
            echo '🧹 Čistim Docker kontejner...'
            sh "docker rm -f ${APP_CONTAINER} || true"
        }
        failure {
            echo '❌ Build nije uspeo — pogledaj logove!'
        }
        success {
            echo '✅ Build uspešno završen — aplikacija radi!'
        }
    }
}
