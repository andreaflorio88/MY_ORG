@isTest
public class AccountProcessorTest {
    @isTest public static void accnt(){
        Account a = new Account();
        a.Name = 'Test Account';
        Insert a;

        Contact cont = New Contact();
        cont.FirstName ='Bob';
        cont.LastName ='Masters';
        cont.AccountId = a.Id;
        Insert cont;
   
        Set<Id> setAccId = new Set<ID>();
        setAccId.add(a.id);
        
        Test.startTest();
        AccountProcessor.countContacts(setAccId);
        Test.stopTest();
    }
}