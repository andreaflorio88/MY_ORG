pipeline {
    agent any
    tools {
        nodejs '18.14.2'
    }
    stages {
        stage('Check SFDX Installation') {
            steps {
                bat 'sfdx --version'
            }
        }
        stage('Authenticate with Salesforce') {
            steps {
                withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'JWT_KEY')]) {
                    bat 'echo "Path to JWT_KEY: %JWT_KEY%"'
                    bat '''
                    sfdx force:auth:jwt:grant --client-id 3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default-dev-hub
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                bat """
                    sf project deploy start ^
                        --sourcepath manifest/package.xml ^
                        --targetusername DevHub ^
                        --wait 10 ^
                        --verbose
                    """
            }
        }
    }

    post {
        always {
            // Cleanup or notification steps can be added here
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed. Check the logs for details.'
        }
    }
}