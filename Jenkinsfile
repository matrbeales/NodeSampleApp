pipeline {
    agent none
    stages {
        stage("Test") {
            agent {
              label 'ubuntu-node'
            }
            steps {
                cleanWs()
                git url: 'git@github.com:spartaglobal/NodeSampleApp.git', branch: 'master', credentialsId: 'b37b90c9-9927-4e2e-bb08-9023d13653ef'
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
          
            when { tag "v*" }
          
            agent {
              label 'master'
            }
            
            steps {
                cleanWs()
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'GitTagMessageExtension', useMostRecentTag: true]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'b37b90c9-9927-4e2e-bb08-9023d13653ef', name: 'origin', refspec: '+refs/tags/*:refs/remotes/origin/tags/*', url: 'git@github.com:spartaglobal/NodeSampleApp.git']]])
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
            
            when { tag "v*" }
            
            agent {
              label 'master'
            }
            steps {
                cleanWs()
                git url: 'git@github.com:spartaglobal/NodeSampleApp.git', branch: 'master', credentialsId: 'b37b90c9-9927-4e2e-bb08-9023d13653ef'
                sh 'terraform init -input=false'
                sh 'terraform plan -out=tfplan -input=false'
            }
            
            post {
                success {
                  echo "plan created"
                  archiveArtifacts 'tfplan'
                }
            }
        }
        
        stage("Deploy") {
            
            when { tag "v*" }
            
            agent {
              label 'master'
            }
            steps {
                cleanWs()
                input message: 'Would you like to deploy this version?', ok: 'Deploy'
                git url: 'git@github.com:spartaglobal/NodeSampleApp.git', branch: 'master', credentialsId: 'b37b90c9-9927-4e2e-bb08-9023d13653ef'
                sh 'terraform init -input=false'
                sh 'terraform apply "tfplan"'
            }
            
            post {
                success {
                  echo "deployment successfull"
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


 
