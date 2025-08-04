pipeline {
  agent any
  tools {
    maven 'maven'
    jdk 'jdk21'
  }
  parameters {
    string(name: 'ENV',       defaultValue: 'qa', description: 'Ambiente do Karate')
    string(name: 'KARATE_TAGS', defaultValue: '@regression', description: 'Ayude a selecionar cenários')
  }
  triggers {
    cron('H 2 * * *')
  }
  options {
    timestamps()
    timeout(time: 45, unit: 'MINUTES')
    buildDiscarder(logRotator(numToKeepStr: '20', daysToKeepStr: '30'))
  }
  stages {
    stage('Checkout & Test') {
      steps {
        checkout scm
        bat """
          mvn clean test -Dkarate.env=${params.ENV} -Dkarate.options="--tags ${params.KARATE_TAGS}"
        """
      }
    }
  }
  post {
    always {
      junit 'target/surefire-reports/*.xml'
      cucumber buildStatus: 'UNSTABLE',
               fileIncludePattern: '**/*.json',
               jsonReportDirectory: 'target',
               trendsLimit: 20
    }
    success {
      echo 'Pipeline finalizada com sucesso.'
    }
    unstable {
      echo 'Build instável: alguns testes falharam.'
    }
    failure {
      echo 'Erro grave no build, verifique o console.'
    }
    post {
    always {
        publishHTML (target: [
            reportDir: 'target/karate-reports',
            reportFiles: 'karate-summary.html',
            reportName: 'Relatório Karate',
            keepAll: true,
            alwaysLinkToLastBuild: true
        ])
    }
}

  }
}
