pipeline {
    agent any
    tools {
        maven 'mvnd'   // Certifique-se de configurar a ferramenta Maven chamada "mvnd" no Jenkins
        jdk 'jdk21'    // Certifique-se de que o JDK 21 esteja definido corretamente no Jenkins
    }
    parameters {
        string(name: 'ENV', defaultValue: 'qa', description: 'Ambiente do Karate')
        string(name: 'KARATE_TAGS', defaultValue: '@regression', description: 'Use para selecionar cenários')
    }
    triggers {
        cron('H 2 * * *')  // Executa às 2h diariamente
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
                    mvnd clean test ^
                      -Dkarate.env=${params.ENV} ^
                      -Dkarate.options="--tags ${params.KARATE_TAGS}"
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
    }
}
