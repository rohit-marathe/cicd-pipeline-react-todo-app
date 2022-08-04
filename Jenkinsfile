
pipeline{

	agent any

	environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerhub-rohit-marathe')
	}

	stages {

		stage('Build') {

			steps {
				sh 'docker build -t rohitmarathe/todo:latest .'
			}
		}

		stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('Push') {

			steps {
				sh 'docker push rohitmarathe/todo:latest'
			}
		}

        stage('run') {

			steps {
				sh 'docker run -d -p 80:80 rohitmarathe/todo:latest'
			}
		}
	}

	post {
		always {
			sh 'docker logout'
		}
	}

}
