pipeline {
    agent any
    tools {
        nodejs '18.14.2'
    }
    environment {

        SF_DEPLOY = "${params['Deploy con test']}"
        PACKAGE = "${params['Package da utilizzare']}"
        SF_VALIDATION = "${params['Solo validazione']}"
        SF_ENV = "${params['Ambiente di destinazione']}"

        REQUEST = 'Deploy without test class'
        TESTS = "AccountTriggerHandlerTest," + 
                "RiportafogliazioneTest"

    }
    stages {
        stage('Check SFDX Installation') {
            steps {
                bat 'sf --version'
            }
        }
        stage('Salesforce Authentication') {
            steps {
                withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'JWT_KEY')]) {
                    echo "Running authentication..."
                    bat """
                    sf org login jwt --client-id 3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default-dev-hub
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

                        echo 'SF_ENV: ' + "${SF_ENV}"
                        echo 'PACKAGE: ' + "${PACKAGE}"
                        echo 'SF_VALIDATION: ' + "${SF_VALIDATION}"

                        if("${params['Classi di test da eseguire (opz.)']}") {
                            classes = "${params['Classi di test da eseguire (opz.)']}"
                        }

                        def classesArray = TESTS.split(',').collect { it.trim() }
                        classes = classesArray.join(' ')
                        echo 'TESTS: ' + "${classes}"
                        
                        echo "Running authentication..."
                        bat """
                        sf org login jwt --client-id 3MVG98Gq2O8Po4Zm6Dx8POjKJh1uGBbGl9QeBG7vEJDEl4JFgmOJJTDpXl3Lx8ksQpmDDsUt54xnXI_xBCsXk --jwt-key-file "%JWT_KEY%" --username andreaflorio88@yahoo.it.new --instance-url https://login.salesforce.com --set-default
                        """

                        if(deploy == 'true') {
                            REQUEST = 'Deployment with test class'
                            echo "Running deploy with test class..."
                            bat """
                            sf project deploy start --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests --tests ${classes} --wait 10 --verbose
                            """
                        }
                        else if(validation == 'true') {
                            REQUEST = 'Validation'
                            echo "Running validation..."
                            bat """
                            sf project deploy validate --target-org andreaflorio88@yahoo.it.new --manifest ${manifestPath} --test-level RunSpecifiedTests --tests ${classes} --wait 10 --verbose --json
                            """
                        } else {
                            echo "Running deploy without test class..."
                            bat """
                            sf project deploy start --manifest ${manifestPath} --target-org 00D7R0000047XLo!AR0AQC0GgilI3xNcLgyd3lQKMg92Zb3GKH2DV0MrNJ2nUienO4B9qYaRGT3.2xfC1lmYMOeSAXJo1pRaktRSbPErlH3RQs3B
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
