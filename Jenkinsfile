pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DEV_REPO   = 'vkeshwam1/dev'
        PROD_REPO  = 'vkeshwam1/prod'
        SERVER_IP  = '3.91.38.48'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'chmod +x build.sh && BUILD_NUMBER=${BUILD_NUMBER} ./build.sh'
            }
        }

        stage('Docker Login') {
            steps {
                sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | \
                      docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                """
            }
        }

        stage('Push to Dev') {
            when {
                branch 'dev'
            }
            steps {
                sh """
                    docker tag vkeshwam1/dev:latest ${DEV_REPO}:${BUILD_NUMBER}
                    docker push ${DEV_REPO}:${BUILD_NUMBER}
                    docker push ${DEV_REPO}:latest
                """
            }
        }

        stage('Push to Prod') {
            when {
                branch 'master'
            }
            steps {
                sh """
                    docker tag vkeshwam1/dev:latest ${PROD_REPO}:${BUILD_NUMBER}
                    docker push ${PROD_REPO}:${BUILD_NUMBER}
                    docker push ${PROD_REPO}:latest
                """
            }
        }

        stage('Deploy to Server') {
            steps {
                sh """
                    ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/deploy-key.pem \
                      ubuntu@${SERVER_IP} \
                      'echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin && \
                       docker pull vkeshwam1/dev:latest && \
                       docker stop app || true && \
                       docker rm app || true && \
                       docker run -d --name app -p 80:80 --restart always vkeshwam1/dev:latest'
                """
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
            cleanWs()
        }
    }
}
