@isTest
public class DatabaseGenericResultTest {
    
    @isTest
    public static void accessAttributes(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
		List<Database.saveResult> results = Database.insert(accounts);
        List<DatabaseGenericResult> genericResults = DatabaseGenericResult.resultsToGenericResults(results);
        genericResults[0].isSuccess();
        genericResults[0].getErrors();
    }
    @isTest
    public static void resultsToGenericResultsUpsert(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
		List<Database.UpsertResult> results = Database.upsert(accounts);
        DatabaseGenericResult.resultsToGenericResults(results);
        
    }
    @isTest
    public static void resultsToGenericResultsInsertUpdate(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
		List<Database.saveResult> results = Database.insert(accounts);
        DatabaseGenericResult.resultsToGenericResults(results);
        
    }
    @isTest
    public static void resultsToGenericResultsDelete(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
		insert accounts;
        
        List<Account> accountsToDelete =  [SELECT Id FROM Account];
        List<Database.deleteResult> results = Database.delete(accountsToDelete);
        DatabaseGenericResult.resultsToGenericResults(results);
        
    }
    @isTest
    public static void resultsToGenericResultsUndelete(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
		insert accounts;
        delete accounts;
        List<Account> accountsToUnDelete =  [SELECT Id FROM Account ALL ROWS];
        List<Database.undeleteResult> results = Database.undelete(accountsToUnDelete);
        DatabaseGenericResult.resultsToGenericResults(results);
        
    }

}