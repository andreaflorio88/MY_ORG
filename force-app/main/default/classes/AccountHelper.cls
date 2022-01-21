public class AccountHelper{

//metodo richiamato nel trigger
public static void CreateAccount(List<Account> AccountNewListFromTrigger){

//SetIn 
set<String> AccountFirstNameIn=new Set<String>();
//set<String> BillingAddressIn=new Set<String>();



//SetOld 
set<String> AccountFirstNameOld=new Set<String>();
set<String> BillingAddressOld=new Set<String>();



//Attuali
for(Account AccountNew: AccountNewListFromTrigger){

    AccountFirstNameIn.add(AccountNew.Name);
    //AccountLastNameIn.add(AccountNew.LastName);
    //BillingAddressIn.add(AccountNew.BillingAddress);
    //PersonMobilePhoneIn.add(AccountNew.PersonMobilePhone);
    //PersonEmailIn.add(AccountNew.PersonEmail);
    //PersonBirthdateIn.add(AccountNew.PersonBirthdate);
   
}
//Ricercare a db gli Account presenti e riempimento set
Map<String,Account> mappaAccount=new Map<String,Account>();
String chiave;
List <Account> attuali=[Select id,Name from Account where Name in:AccountFirstNameIn ];

 for(Account att:attuali){
    if(attuali.isEmpty()){
    System.debug('sono qui');
   
            List<Account> AccountIds=new List<Account>();
            AccountIds.add(att);
            chiave = att.Name;
            mappaAccount.put(chiave, att);
            
            System.debug('non esiste');
    } 
    else{
       System.debug('esiste');
       att.addError('It is not possible ');
                
        
      
        }
         
        
           
    }     
  
  
} }