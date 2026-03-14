pipeline {
    agent any
    environment {
        IMAGE_NAME = "rishiakrishnan/trend-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDS = credentials('docker')
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }
        stage('Login to DockerHub') {
            steps {
                sh '''
                echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                '''
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                sh '''
                docker push $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
        stage('Update Kubernetes Deployment') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml

                kubectl rollout status deployment/my-deployment
                '''
            }
        }
    }
    post {
        success {
            echo "Deployment Successfull"
        }

        failure {
            echo "Pipeline Faileds"
        }
    }
}