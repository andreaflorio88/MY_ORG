public with sharing class searchAccountController {
 
    @AuraEnabled
    public static List < account > fetchAccount(String searchKeyWord) {
    String searchKey = searchKeyWord + '%';
    List < Account > returnList = new List < Account > ();
    List < Account > lstOfAccount = [SELECT id, Name, Type, Industry, Phone, Fax, IsActive__c FROM account
                                   WHERE Name LIKE: searchKey LIMIT 80];
 
    for (Account acc: lstOfAccount) {
        returnList.add(acc);
    }
    return returnList;
}

    @AuraEnabled
    public static List<Account> searchAccount(String accountId) {

        if (accountId != '') {

            //String key = accountId + '%';

            //System.debug('SELECT Id, Name, Phone, Email__c FROM Account WHERE Id LIKE \'' + key + '\' ORDER BY CreatedDate DESC');
            //return [SELECT Id, Name, Phone, Birthdate__c, CreatedDate, Email__c, IsActive__c, Age__c  FROM Account WHERE Id Name :key ORDER BY CreatedDate DESC];

            return [SELECT Id, Name, Phone, Birthdate__c, CreatedDate, Email__c, IsActive__c, Age__c  FROM Account WHERE Id = :accountId ORDER BY CreatedDate DESC];
        }
        return null;
    }

    @AuraEnabled
    public static void deleteRecord(String accountId) {
        System.debug('delete method start');
        delete [SELECT Id FROM Account WHERE Id = :accountId];
    }

    @AuraEnabled
    public static void updateRecord(Account currAcc) {
        update currAcc;
    }

    @AuraEnabled (cacheable = true)
    public static List<Account> searchAccountView(String accName) {
        string strAccName = '%'+ accName + '%';
        return [Select Id, Name, Website, Industry, Phone from Account WHERE Name LIKE: strAccName ];
    }

    @AuraEnabled(cacheable = true)
    public static SetupAuditTrailInfo getRecords(Integer queryLimit, Integer queryOffset) {
        return new SetupAuditTrailInfo([SELECT count() FROM SetupAuditTrail],
        [SELECT Id, Action, CreatedBy.Name, Display, Section, CreatedDate 
                FROM SetupAuditTrail 
                ORDER BY CreatedDate DESC 
                LIMIT :queryLimit 
                OFFSET :queryOffset]);
    }
    
    public class SetupAuditTrailInfo{

        @AuraEnabled
        public Integer totalRecordCount {get;set;}

        @AuraEnabled
        public List<SetupAuditTrail> auditTrailRecords{get;set;}

        public SetupAuditTrailInfo(Integer totalRecordCount, List<SetupAuditTrail> auditTrailRecords){
            this.totalRecordCount = totalRecordCount;
            this.auditTrailRecords = auditTrailRecords;
        }
    }

}