@isTest
public class AccountManagerTest {
    
    @isTest
    static void test(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        Contact con = new Contact(LastName = 'Test', AccountId = acc.Id);
        insert con;
        
        Id accountId = acc.Id;
        RestRequest request = new RestRequest();
        request.requestUri = 'https://prova1234-dev-ed.my.salesforce.com/services/Accounts/'+ accountId + 'contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        Account account = AccountManager.getAccount();
        Test.stopTest();
    }
}