pipeline {
    agent any
    tools {
        nodejs '18.14.2'
    }
    environment {
        REQUEST = 'Deploy without test class'
        SF_ENV = "${params['Ambiente di destinazione']}"
        SF_VALIDATION = "${params['Solo validazione']}"
        SF_DEPLOY = "${params['Deploy con test']}"
        PACKAGE = "${params['Package da utilizzare']}"
        TEST_CLASSES = "${params['Classi di test da eseguire (opz.)']}"
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
                        def test_classes = "${env.TEST_CLASSES}"
                        def deploy = "${env.SF_DEPLOY}"

                        echo 'SF_ENV: ' + "${SF_ENV}"
                        echo 'PACKAGE: ' + "${PACKAGE}"
                        echo 'SF_VALIDATION: ' + "${SF_VALIDATION}"
                        echo 'TEST_CLASSES: ' + "${TEST_CLASSES}"

                        if(TEST_CLASSES != null) {
                            classes = test_classes
                        }

                        def classesArray = classes.split(',').collect { it.trim() }
                        classes = classesArray.collect { "--tests " + it }.join(' ')
                        echo 'TESTS: ' + "${classes}"
                        
                        echo "Running authentication..."
                        bat """
                        sfdx force:auth:jwt:grant --client-id 3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default
                        """

                        if(deploy == 'true') {
                            REQUEST = 'Deployment with test class'
                            echo "Running deploy with test class..."
                            bat """
                            sf project deploy start --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests ${classes}
                            """
                        }
                        else if(validation == 'true') {
                            REQUEST = 'Validation'
                            echo "Running validation..."
                            bat """
                            sf project deploy validate --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests ${classes} --wait 10 --verbose --json
                            """
                        } else {
                            echo "Running deploy without test class..."
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
            echo 'Pipeline execution finished.'
        }
        success {
            echo "${REQUEST} was successful!"
        }
        failure {
            echo "${REQUEST} failed. Check the logs for details."
        }
    }
}
