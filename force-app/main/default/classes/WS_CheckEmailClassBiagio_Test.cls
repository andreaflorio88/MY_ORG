@isTest
global class WS_CheckEmailClassBiagio_Test {
    @isTest
    static void testInsertAccount(){
        Account acc = new Account(Name = 'test', Email__c = 'test@test.com');
        insert acc;
        test.startTest();
        WS_CheckEmailClassBiagio.Customer dt = new WS_CheckEmailClassBiagio.Customer();
        dt.Email = acc.Email__c;
        dt.AccountId = acc.Id;
        WS_CheckEmailClassBiagio.verifyAccountEmail(dt);
        test.stopTest();
        System.assertEquals(dt.Email, acc.Email__c);
        System.assertEquals(dt.AccountId, acc.Id);
        
    }
    @isTest
    static void testEmailBlank(){
        Account acc = new Account(Name = 'test');
        insert acc;
        test.startTest();
        WS_CheckEmailClassBiagio.Customer dt = new WS_CheckEmailClassBiagio.Customer();
        WS_CheckEmailClassBiagio.verifyAccountEmail(dt);
        test.stopTest();
        System.assertEquals(null, acc.Email__c);
    }    
}