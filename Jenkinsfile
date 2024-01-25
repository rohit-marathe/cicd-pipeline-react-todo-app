pipeline {
    agent any

    tools {
        jdk 'jdk17'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        ARGOCD_SERVER_URL = '3.23.247.74:31159'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/rohit-marathe/cicd-pipeline-react-todo-app.git'
            }
        }

        stage("Sonarqube Analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=ReactTodo -Dsonar.projectKey=ReactTodo"
                }
            }
        }

        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

        stage("Docker Build & Push to Docker Hub"){
            steps {
                echo "Pushing the image to Docker hub"
                withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                    sh "docker build -t ${env.dockerHubUser}/todo:1.0 ."
                    sh "docker push ${env.dockerHubUser}/todo:1.0"
                }
            }
        }

        stage("TRIVY") {
            steps {
                sh "trivy image rohitmarathe/todo:1.0 > trivyimage.txt"
            }
        }

        stage('Sync ArgoCD Application') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId:"argocd-credentials",passwordVariable:"ARGOCD_PASSWORD",usernameVariable:"ARGOCD_USERNAME")]) {
                        // Log in to ArgoCD using direct access to Kubernetes API server
                        sh "argocd login ${env.ARGOCD_SERVER_URL} --insecure --username ${env.ARGOCD_USERNAME} --password ${env.ARGOCD_PASSWORD}"
                        
                        // Now you can perform other ArgoCD operations, such as syncing applications
                        sh "argocd --insecure --grpc-web --server ${env.ARGOCD_SERVER_URL} app sync todo"
                    }
                }
            }
        }
    }
}
