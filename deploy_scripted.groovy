node {
    // Definizione delle variabili
    def SF_DEPLOY = "${params['Deploy con test']}"
    def PACKAGE = "${params['Package da utilizzare']}"
    def SF_VALIDATION = "${params['Solo validazione']}"
    def SF_ENV = "${params['Ambiente di destinazione']}"
    def CLIENTID = "3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk"
    def REQUEST = 'Deploy without test class'
    def TESTS = "AccountTriggerHandlerTest," + 
                "RiportafogliazioneTest"
    def classes

    stage('Check SFDX Installation') {
        bat 'sfdx --version'
    }

    stage('Salesforce Authentication') {
        withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'JWT_KEY')]) {
            echo "Running authentication..."
            bat """
            sfdx force:auth:jwt:grant --client-id ${CLIENTID} --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default-dev-hub
            """
        }
    }

    stage('Deploy') {
        dir('sfdx-project.json') {
            withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'JWT_KEY')]) {
                def manifestPath = "manifest/${PACKAGE}"
                def environment = "${SF_ENV}"
                def validation = "${SF_VALIDATION}"
                def deploy = "${SF_DEPLOY}"

                echo "SF_ENV: ${SF_ENV}"
                echo "PACKAGE: ${PACKAGE}"
                echo "SF_VALIDATION: ${SF_VALIDATION}"

                // Gestione delle classi di test
                if ("${params['Classi di test da eseguire (opz.)']}") {
                    classes = "${params['Classi di test da eseguire (opz.)']}"
                } else {
                    classes = TESTS
                }

                def classesArray = classes.split(',').collect { it.trim() }
                classes = classesArray.collect { "--tests " + it }.join(' ')
                echo "TESTS: ${classes}"

                echo "Running authentication..."
                bat """
                sfdx force:auth:jwt:grant --client-id ${CLIENTID} --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default
                """

                if (deploy == 'true') {
                    REQUEST = 'Deployment with test class'
                    echo "Running deploy with test class..."
                    bat """
                    sf project deploy start --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests ${classes} --wait 10 --verbose
                    """
                } else if (validation == 'true') {
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