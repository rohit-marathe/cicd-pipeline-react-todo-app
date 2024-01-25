pipeline {
    agent any

    tools {
        jdk 'jdk17'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        ARGOCD_SERVER_URL = withCredentials([string(credentialsId: 'argocd-server', variable: 'ARGOCD_SERVER_URL')]) { return "${ARGOCD_SERVER_URL}" }
        ARGOCD_CREDENTIALS = credentials('argocd-credentials')
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

        stage('Docker Build & Push to Docker Hub') {
            steps {
                echo "Pushing the image to Docker hub"
                withCredentials([usernamePassword(credentialsId: "dockerHub", passwordVariable: "dockerHubPass", usernameVariable: "dockerHubUser")]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                    sh "docker build -t ${env.dockerHubUser}/todo:1.1 ."
                    sh "docker push ${env.dockerHubUser}/todo:1.1"
                }
            }
        }

        stage("TRIVY") {
            steps {
                sh "trivy image rohitmarathe/todo:1.1 > trivyimage.txt"
            }
        }

        stage('Sync ArgoCD Application') {
            steps {
                script {
                    // Log in to ArgoCD using direct access to Kubernetes API server
                    withCredentials([string(credentialsId: 'argocd-server', variable: 'ARGOCD_SERVER_URL'),
                                     usernamePassword(credentialsId: ARGOCD_CREDENTIALS, passwordVariable: 'ARGOCD_PASSWORD', usernameVariable: 'ARGOCD_USERNAME')]) {
                        sh "argocd login ${ARGOCD_SERVER_URL} --insecure --username ${ARGOCD_USERNAME} --password ${ARGOCD_PASSWORD}"
                    }

                    // Now you can perform other ArgoCD operations, such as syncing applications
                    sh "argocd --insecure --grpc-web --server ${ARGOCD_SERVER_URL} app sync todo"
                }
            }
        }
    }
}
