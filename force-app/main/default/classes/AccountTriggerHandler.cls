public class AccountTriggerHandler {
	
    public static void handleAfterInsert(List<Account> accounts) {
        
        for(Account acc: accounts) {
        	System.debug('test');    
        }
        
    }
    
}
