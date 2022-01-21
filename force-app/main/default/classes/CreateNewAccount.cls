public with sharing class CreateNewAccount {
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        return [SELECT Id, Name FROM Account WHERE Id = :accountId];
    }
    
    @AuraEnabled
    public static Contact saveNewContact(Contact contact, Id accountId) {
        contact.accountId = accountId;
        upsert contact;    
        return contact;
       
    }
}