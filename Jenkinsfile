pipeline {
    agent any
    environment {
        IMAGE_NAME = "rishiakrishnan/trend-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDS = credentials('docker')
        PATH = "/usr/local/bin:/usr/bin:/bin"
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
        stage('Debug Environment') {
            steps {
                sh '''
                echo "USER:"
                whoami
                echo "PATH:"
                echo $PATH
                echo "Kubectl Location:"
                which kubectl || true
                '''
            }
        }
        stage('Update Kubernetes Deployment') {
            steps {
                sh '''
                aws eks --region us-east-1 update-kubeconfig --name my-eks-test
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
            echo "Pipeline Failed"
        }
    }
}