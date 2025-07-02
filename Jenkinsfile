pipeline {
    agent any

    environment {
        APP_IMAGE = 'gs-rest-service'
        APP_PORT = '777'
        APP_CONTAINER = 'test-app'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo '🔧 Građenje Docker slike...'
                sh "docker build -t ${APP_IMAGE} ."
            }
        }

        stage('Run Container') {
            steps {
                echo '🚀 Pokretanje aplikacije...'
                sh "docker run -d -p ${APP_PORT}:8080 --name ${APP_CONTAINER} ${APP_IMAGE}"
            }
        }

        stage('Wait for App to Respond') {
    steps {
        sh '''
            echo "⏳ Čekam da se aplikacija pokrene..."

            for i in {1..12}; do
              if curl -fs http://localhost:777/greeting > /dev/null; then
                echo "✅ Endpoint je spreman!"
                break
              fi
              echo "❌ Endpoint nije spreman... pokušaj $i"
              sleep 2
            done
        '''
    }
}

        }

        stage('Test Greeting Endpoint') {
            steps {
                echo '📡 Testiram endpoint...'
                sh "curl -f http://localhost:777/greeting"
            }
        }
    }

    post {
        always {
            echo '🧹 Čistim kontejner...'
            sh "docker rm -f ${APP_CONTAINER} || true"
        }
        success {
            echo '✅ Build uspešan!'
        }
        failure {
            echo '❌ Build neuspešan. Proveri logove.'
        }
    }
}
