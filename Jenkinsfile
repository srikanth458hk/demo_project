pipeline {
    agent any
    triggers('* * * * *')
    stages {
        stage('vcs'){
            steps {
                git branch: 'master' , url: 'https://github.com/sahat/hackathon-starter.git' 
                
            }
        }
        stage ('docker image build') {
            steps {
                sh 'docker image build -t reponame/images:hackathon-starter-ver0.1 .'

            }

        }
        
    stage('SonarQube analysis') {
    environment {
      SCANNER_HOME = tool 'Sonar-scanner'
    }
    steps {
    withSonarQubeEnv(credentialsId: 'sonar-credentialsId', installationName: 'Sonar') {
         sh '''$SCANNER_HOME/bin/sonar-scanner \
         -Dsonar.projectKey=projectKey \
         -Dsonar.projectName=projectName \
         -Dsonar.sources=src/ \
         -Dsonar.java.binaries=target/classes/ \
         -Dsonar.exclusions=src/test/java/****/*.java \
         -Dsonar.java.libraries=/var/lib/jenkins/.m2/**/*.jar \
         -Dsonar.projectVersion=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}'''
       }
     }
}
         
    stage('SQuality Gate') {
     steps {
       timeout(time: 1, unit: 'MINUTES') {
       waitForQualityGate abortPipeline: true
       }
  }
}

     stage ('push the image to registry')
              steps {
                sh 'docker image push reponame/images:hackathon-starter-ver0.1'
            }
        }

        stage('creating infrastructure'){
            steps{

                sh 'terraform init'
                sh 'terraform apply --auto-approve'

            }
        }
        stage('Deploy'){
            steps {
                kubectl apply -f deploy&svc.yaml
            }
        }

    }
}