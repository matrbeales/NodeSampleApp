#!/usr/bin/env groovy

pipeline {

  node('ubuntu-node')
    stages {
      stage('Build') {
            steps {
                echo 'Building..'
                sh 'npm install'
            }
      }
      stage('Test') {
        steps {
            echo 'Testing..'
            sh 'npm run test-unit'
        }
      }
    }
  }
}