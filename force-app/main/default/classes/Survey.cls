public with sharing class Survey {
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        return [SELECT Id, Name FROM Account WHERE Id = :accountId];
    }
    
    @AuraEnabled
    public static SurveyTest__C saveSurvey(SurveyTest__C survey, Id accountId) {
        survey.Account__c = accountId;
        upsert survey;    
        return survey;
       
    }
}