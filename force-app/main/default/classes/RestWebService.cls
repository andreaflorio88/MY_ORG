public with sharing class RestWebService {

    @AuraEnabled
    public static List<Rest_Web_Service__c> getRestWebserviceList() {
        return [SELECT Name, Name__c, isActive__c, Source__c, LastModifiedDate FROM Rest_Web_Service__c];
    }

    @AuraEnabled
    public static void updateWS(String ws, Boolean isActive) {

        Rest_Web_Service__c restWS = [SELECT Name, isActive__c FROM Rest_Web_Service__c WHERE Name__c = :ws];
        restWS.isActive__c = isActive;

        update restWS;
    }

}