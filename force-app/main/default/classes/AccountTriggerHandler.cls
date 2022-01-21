public class AccountTriggerHandler {
	
    public static void beforeInsertChecks(List<Account> accounts){
              
    }
    
    public static void beforeUpdateChecks(List<Account> accounts){
        
    }
    
    public static void afterInsertChecks(List<Account> accounts){
        createContact(accounts);
    }
    
    public static void afterUpdateChecks(List<Account> accounts){
      
    }
    
    private static void createContact(List<Account> accounts){
      	System.debug('@@@ '+ accounts);
        List<Contact> contacts = new List<Contact>();
        
        for(Account a : accounts){
            contacts.add(new Contact(LastName = a.Name, AccountId = a.Id));
        }
        System.debug('@@@ '+ contacts);
        if(!contacts.isEmpty()){
    		insert contacts;
        }
    }
}