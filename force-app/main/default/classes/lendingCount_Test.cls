@isTest
public with sharing class lendingCount_Test {
    
    @isTest    
    private static void afterInsert(){     
        
        Account account = new Account(Name='TestAccount');
        insert account;
        
        List<lending__c> lenlst = new List<lending__c>();
        for (Integer i = 0; i <= 5; i++) {
            lending__c len = new lending__c();
            len.Trial_Periods__c = account.id;
            lenlst.add(len);
        }
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        try {
            System.runAs(u) {
                insert lenlst; 
            }
        } 
        catch(Exception e)
        {
            System.debug('ERROR');
        }
    }   
    
}