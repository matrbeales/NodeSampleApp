pipeline {
    agent none
    stages {
        stage("Test") {
            agent {
              label 'ubuntu-node'
            }
            steps {
                dir('app') {
                    sh 'npm install'
                    sh 'npm run test-unit'
                    sh 'npm run test-integration'
                }
                setBuildStatus("Build complete", "SUCCESS");
            }
            post {
                failure {
                  setBuildStatus("Build failed", "FAILURE");
                }
            }
        }
        
        stage("Build") {
          
            when { tag "v*.*.*" }
          
            agent {
              label 'master'
            }
            
            steps {
                script {
                    env.GIT_TAG_NAME = sh(returnStdout: true, script: "git tag --sort version:refname | tail -1").trim()
                }
                sh 'packer validate packer.json'
                sh 'packer build packer.json'
            }
            
            post {
                success {
                  echo "built successfully"
                }
            }
        }
        
        stage("Plan") {
            
            when { tag "v*.*.*" }
            
            agent {
              label 'master'
            }
            steps {
                sh 'terraform init -input=false'
                sh 'terraform plan -out=tfplan -input=false'
            }
            
            post {
                success {
                  echo "plan created successfully"
                  archiveArtifacts 'tfplan'
                }
            }
        }
        
        stage("Deploy") {
            
            when { tag "v*.*.*" }
            
            agent {
              label 'master'
            }
            steps {
                sh 'terraform init -input=false'
                sh 'terraform apply "tfplan"'
            }
            
            post {
                success {
                  echo "deployment successful"
                }
            }
        }
    }
}


void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "git@github.com:spartaglobal/NodeSampleApp.git"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}


 
