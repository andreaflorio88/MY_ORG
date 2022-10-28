public class AccountClass { 
	
    // Id 
    // String 
    // Integer
    // Decimal
    
    //String.valueOf()   
    //Integer.valueOf()
    //Decimal.valueOf()
    
    
    // devo settare un valore di un Account/Contact --> VOID con UPDATE
    // devo restituire un valore --> RETURN
    // devo aggiornare e restituire --> RETURN con UPDATE
    
    
    // INSERT UPDATE DELETE --> 1 record, una lista
    
    // metodo per farci restituire l'età di un account
    public static Integer getAccountAge(Id accountId){
        Integer eta;
        Account currAcc = [SELECT Id, Age__c FROM Account WHERE Id = :accountId];
        if(currAcc != null){
            eta = Integer.valueOf(currAcc.Age__c);
        }  
        return eta;
    }
    
    // somma tra numeri interi
    public static Integer somma2Numeri(Integer a, Integer b){
        Integer somma = a + b;
        return somma;
    }
    
    private static void createContactForAccount(Id accountId){
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = accountId;
        insert con;
    }
    // do al metodo 2 numeri
    // faccio la sottrazione
    // ritorno il risultato
    public static Integer sottrazioneTraDueNumeri (Integer a, Integer b){
        Integer risultato;
        risultato  = a - b;
   		return risultato;
    }
    
    //do al metodo due numeri
    //controllo il numero più grande
    //faccio la sottrazione
    //ritorno il risultato
   
    public static Integer sottrazioneTraDueNumeri2 (Integer a, Integer b){
        Integer risultato = 0;
        if(a>b)
            risultato = a-b; 
		else
            risultato = b-a;
    return risultato;
            
    }
    
    // prendi un account e sett il campo fax
    // selezionare un account 
    // inserire il numero 
    public static void inserisciNumeroFax (String accountId, String fax){
        Account currAcc = [Select id, Fax From Account Where Id =:accountId];
        if(currAcc != null){
            currAcc.Fax = fax;
        }  
		//update currAcc;
    }
    
    
    public static void aggiornareEta (String accountId ) {
        Account currAcc = [Select Id, Birthdate__c, Eta__c From Account Where Id = :accountId];
        if (currAcc != null){
        	if (currAcc.Birthdate__c != null)
                currAcc.Eta__c = Date.today().year() - currAcc.Birthdate__c.year();
        }
        update currAcc;
    }
    
    
    // prendi una lista account
    // controlla se sono attivi 
    // se sono true setti il campo eta 
    // se sono false associ un contatto 
     
    public static void checkAttivi (){
        List<Account> accounts = [SELECT Id, IsActive__c, Eta__c FROM Account LIMIT 5];
        List<Account> accountToUpdate = new List<Account>();
        
        for(Account currAcc: accounts){
            if(currAcc.IsActive__c == true){
                aggiornareEta(currAcc.Id);
                accountToUpdate.add(currAcc);
            }
            else 
                createContactForAccount(currAcc.Id);
        }
        update accountToUpdate;
    }
    
    
    /************************* IF --> if(controllo){fai qualcosa} ************************
    ELESE IF --> else if(controllo) {fai qualcosa}
    ELESE --> {fai qualcosa}
    
    if(a>b){
        fai qualcosa;
    } else if(a>c){
        fai qualcosa;
	} else {
		fai qualcosa;
	} */
    
    
    /************************* FOR LISTE ************************
	
    for(NomeOggetto puntatore: nomeLista){
    	solitamente si inserisce un if, 
		oppure una chiamata ad un metodo che fa dei controlli
    }
	
	List<Account> accounts = new List<Account>(); oppure query
    for(Account acc: accounts){
    	
    }
	*/
    
    /************************ NEW ********************* 
		Oggetto:	Oggetto nomeACaso = new Oggetto();
		Lista:		List<NomeOggetto> nomeACaso = new List<NomeOggetto>(); oppure query
												= [SELECT Id FROM NomeOggetto];
	*/
    
    
    //un metodo dove io passo una lista di account per ogni account crea un contatto con lo stesso nom
    
    public static Void creaUnContatto (List <Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Account a: accounts){
            Contact b = new Contact();
            b.LastName = a.Name;
            b.AccountId = a.Id;
            // aggiungiamo il contatto in lista
            contacts.add(b);
    	}
    	insert contacts;
	}
}
