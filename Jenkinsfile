pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
       }
    stages {
        stage('Set Up Virtual Environment') {
            steps {
                echo 'Ensuring pip is up to date'
                sh 'python3 -m pip install --upgrade pip'
                echo 'Creating a virtual evironment'
                sh 'python3 -m venv .'
                echo 'Activating the virtual environment'
                sh '. bin/activate'
            }
        }
        stage('Build') { 
            steps {
                echo '=== Installing dependencies ==='
                sh 'python3 -m pip install -r requirements.txt'
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
                branch 'master'
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
                branch 'master'
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
            steps {
                echo '=== Delete the local docker images ==='
                sh("docker rmi -f jayeclark/prepple-ml-admin:latest || :")
                sh("docker rmi -f jayeclark/prepple-ml-admin:$SHORT_COMMIT || :")
            }
        }
    }

    post {
      // always is for code that you want to run
      // after EVERY pipeline run
      always {
         // publish our test reports with junit
         junit 'reports/*.xml'
         // Clean the workspace.
         // This deletes everything in the workspace
         cleanWs()
      }
   }
}
