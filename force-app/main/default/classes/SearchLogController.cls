/**
 * Created by cge01625 on 03/07/2019.
 */

public with sharing class SearchLogController {

    @AuraEnabled
    public static List<Log__c> searchLogs(String quoteNumber) {

        if (quoteNumber != '') {

            String key = quoteNumber + '%';

            System.debug('SELECT Id, Evento__c, Esito__c, Messaggio_Errore__c, CreatedDate FROM Log__c WHERE Log_CAI__c = TRUE AND Key__c LIKE \'' + key + '\' ORDER BY CreatedDate DESC');

            return [SELECT Id, Evento__c, Esito__c, Messaggio_Errore__c, CreatedDate FROM Log__c WHERE Log_CAI__c = TRUE AND Key__c LIKE :key ORDER BY CreatedDate DESC];
        }
        return null;
    }

}