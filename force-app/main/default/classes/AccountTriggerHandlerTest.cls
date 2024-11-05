@isTest
public class AccountTriggerHandlerTest {
	
    @isTest
    public static void testInsert(){
        
        Account acc = new Account(Name = 'Test');
        acc.Phone = '3654566765';
 		insert acc;
        
    }
}