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
                aws eks update-kubeconfig --region us-east-1 --name my-eks-test
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                kubectl rollout status deployment/my-deployment
                '''
            }
        }
        stage('Setup Monitoring') {
            steps {
                sh '''
                    helm uninstall monitoring -n monitoring
                    kubectl delete namespace monitoring
                    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                    helm repo update
                    helm install prometheus prometheus-community/prometheus \
                    --namespace monitoring \
                    --create-namespace
                    kubectl get pods -n monitoring

                    helm repo add grafana https://grafana.github.io/helm-charts
                    helm repo update

                    helm install grafana grafana/grafana -n monitoring
                    
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