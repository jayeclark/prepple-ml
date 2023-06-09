pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                git branch: 'master', credentialsId: 'f902d431-5ed8-4710-a982-658caf62f8d0', url: 'https://github.com/jayeclark/prepple-ml.git'
            }
        }
        stage('Set Up Virtual Environment') {
            steps {
                sh 'which python3'
                echo 'Ensuring pip is up to date'
                sh 'python3 -m pip install --upgrade pip'
                sh 'python3 -m venv ~/.venv'
                sh 'source ~/.venv/bin/activate'
            }
        }
        stage('Build') { 
            steps {
                echo "=== Installing dependencies ==="
                sh "ls ~"
                sh "ls"
                sh "ls ${env.WORKSPACE}"
                sh "python3 -m pip install -r ${env.WORKSPACE}/requirements.txt"
            }
        }
        stage('Test') {
            steps {
                echo '=== Testing Prepple ML Application ==='
                sh 'python3 -m pytest --junit-xml=./reports/test_report.xml'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Building Prepple ML Docker Image ==='
                script {
                    app = docker.build("jayeclark/prepple-ml-admin")
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Pushing Prepple ML Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerHubCredentials') {
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Remove local images') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Delete the local docker images ==='
                sh("docker rmi -f jayeclark/prepple-ml-admin:latest || :")
                sh("docker rmi -f jayeclark/prepple-ml-admin:$SHORT_COMMIT || :")
            }
        }
    }
}
