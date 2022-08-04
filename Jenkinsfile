node {
    checkout scm

    def customImage = docker.build("todo:${env.BUILD_ID}")

    customImage.inside {
        sh 'make test'
    }
}
