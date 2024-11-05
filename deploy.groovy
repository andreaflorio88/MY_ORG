pipeline {
    agent any
    tools {
        nodejs '18.14.2'
    }
    environment {
        SF_ENV = "${params['Ambiente di destinazione']}"
        SF_VALIDATION = "${params['Solo validazione']}"
        SF_DEPLOY = "${params['Deploy con test']}"
        PACKAGE = "${params['Package da utilizzare']}"
        TESTS = "AccountTriggerHandlerTest," + 
                "RiportafogliazioneTest" 
    }
    stages {
        stage('Check SFDX Installation') {
            steps {
                bat 'sfdx --version'
            }
        }
        stage('Salesforce Authentication') {
            steps {
                withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'JWT_KEY')]) {
                    bat 'echo "Path to JWT_KEY: %JWT_KEY%"'
                    bat """
                    sfdx force:auth:jwt:grant --client-id 3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default-dev-hub
                    """
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    
                    withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'JWT_KEY')]) {

                        def manifestPath = "manifest/${env.PACKAGE}"
                        def environment = "${env.SF_ENV}"
                        def validation = "${env.SF_VALIDATION}"
                        def classes = "${env.TESTS}"
                        def deploy = "${env.SF_DEPLOY}"

                        echo "${SF_ENV}"
                        echo "${PACKAGE}"
                        echo "${SF_VALIDATION}"
                        echo "${TESTS}"

                        def classesArray = classes.split(',').collect { it.trim() }
                        classes = classesArray.collect { "--tests " + it }.join(' ')
                        echo "${classes}"
                        
                        bat 'echo "Path to JWT_KEY: %JWT_KEY%"'
                        bat """
                        sfdx force:auth:jwt:grant --client-id 3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default
                        """

                        if(deploy == 'true') {
                            echo "Running deploy with test class..."
                            bat """
                            sf project deploy start --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests ${classes}
                            """
                        }
                        else if(validation == 'true') {
                            echo "Running validation..."
                            bat """
                            sf project deploy start --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests ${classes}
                            """
                        } else {
                            bat """
                            sf project deploy start --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --wait 10 --verbose
                            """
                        }
                    }
                }
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
