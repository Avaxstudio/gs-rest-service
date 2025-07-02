pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t gs-rest-service .'
                }
            }
        }

        stage('Test App Endpoint') {
            steps {
                script {
                    // Pokreni kontejner u pozadini
                    sh 'docker run -d -p 777:8080 --name test-app gs-rest-service'

                    // Sačekaj malo da se app podigne
                    sleep time: 5, unit: 'SECONDS'

                    // Testiraj endpoint
                    sh 'curl -f http://localhost:777/greeting'
                }
            }
        }
    }

    post {
        always {
            // Očisti test kontejner
            sh 'docker rm -f test-app || true'
        }
    }
}
