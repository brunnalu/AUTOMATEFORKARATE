pipeline {
    agent any
    tools {
        maven 'mvnd'  // Usando mvnd ao invés de Maven tradicional
        jdk 'Java-11' // Certifique-se de que o JDK 11 está configurado corretamente no Jenkins
    }
    parameters {
        string(name: 'ENV', defaultValue: 'qa', description: 'Ambiente do Karate')
        string(name: 'KARATE_TAGS', defaultValue: '@regression', description: 'Ayude a selecionar cenários')
    }
    triggers {
        cron('H 2 * * *')  // Executar o pipeline às 2h todos os dias
    }
    options {
        timestamps()
        timeout(time: 45, unit: 'MINUTES')  // Timeout após 45 minutos
        buildDiscarder(logRotator(numToKeepStr: '20', daysToKeepStr: '30'))  // Manter os 20 últimos builds e os 30 últimos dias de logs
    }
    stages {
        stage('Checkout & Test') {
            steps {
                checkout scm
                sh """
                    mvnd clean test \  // Usando mvnd em vez de mvn
                        -Dkarate.env=${params.ENV} \  // Passando o ambiente para o Karate
                        -Dkarate.options="--tags ${params.KARATE_TAGS}"  // Usando tags configuradas
                """
            }
        }
    }
    post {
        always {
            junit 'target/surefire-reports/*.xml'  // Gerar relatórios de testes
            cucumber buildStatus: 'UNSTABLE',
                     fileIncludePattern: '**/*.json',
                     jsonReportDirectory: 'target',
                     trendsLimit: 20  // Gerar relatórios de Cucumber
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
