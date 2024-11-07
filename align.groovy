#!groovy

import groovy.json.JsonSlurperClassic

node {

    def PACKAGE = params['Package da utilizzare']

    // -------------------------------------------------------------------------
    // Push to PARTIAL5
    // -------------------------------------------------------------------------

    stage('Push to PARTIAL5') {
        build job: 'Deploy', parameters: [booleanParam(name: 'Esegui i test', value: false), string(name: 'Ambiente di destinazione', value: 'PARTIAL5'), string(name: 'Package da utilizzare', value: PACKAGE)]
    }

    // -------------------------------------------------------------------------
    // Push to FULL
    // -------------------------------------------------------------------------

    stage('Push to FULL') {
        build job: 'Deploy', parameters: [booleanParam(name: 'Esegui i test', value: false), string(name: 'Ambiente di destinazione', value: 'FULL'), string(name: 'Package da utilizzare', value: PACKAGE)]
    }
}