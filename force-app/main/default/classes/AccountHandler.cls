public class AccountHandler {
	
    public static Account insertNewAccount(String name){
        try{
            Account currAcc = new Account(Name = name);
            Database.insert(currAcc);
            
            return currAcc;
        } catch(Exception ex){
            return null;
        }
    }
}