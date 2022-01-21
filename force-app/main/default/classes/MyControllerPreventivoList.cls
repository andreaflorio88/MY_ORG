public class MyControllerPreventivoList {

    // Variabili
    private final List<Cliente__c> preventivolist;
    private final List<Preventivo__c> clientelist;
    private final List<Tappa__c> tappalist;
    
    // Passaggio id da update, delete, detail
    public string idkeyclik {get; set;}


    //Costruttore
    public MyControllerPreventivoList () {
        preventivolist= [SELECT Id, Name, Indirizzo__c , Telefono__c,  Nome__c FROM Cliente__c ]; 
               //    WHERE Id = :ApexPages.currentPage().getParameters().get('id')
                 
        
        
    }

    public List<Cliente__c>  getPreventivolist() {
        return preventivolist;
    }

    public List<Preventivo__c>  getRichiedentelist() {
        return clientelist;
    }
    
    public List<Tappa__c>  getTappalist() {
        return tappalist;
    }




//Elenco Interazioni

    //Azione New
    public PageReference create() {

    //Redirect to new record page
    PageReference pageRef = new PageReference('/apex/Custom_page');
            return pageRef;
    }
    
    
    
    
     //Azione Detail Standard
    public PageReference detail() {
    
    //Redirect to detail page standard
    PageReference pageRef = new PageReference('/apex/Detail_cliente?id='+idkeyclik);
         pageRef.setRedirect(true);
         return pageRef;
    } 
    
    
    
        //Azione Modifica Standard
    public PageReference modifica() {
    
    //Redirect to detail page standard
    PageReference pageRef = new PageReference('/apex/Cliente?id='+idkeyclik);
         pageRef.setRedirect(true);
         return pageRef;
    }
    
    
    
    //Azione UpdateAllList Record
    public PageReference save() {
       //Richiedente__c ric = [SELECT Id FROM Richiedente__c WHERE Id=:idkeyclik LIMIT 1];
       //Richiedente__c  ric = new Richiedente__c(id=idkeyclik);
       update preventivolist;

    //Redirect after update to list page
    PageReference pageRef = new PageReference('/apex/MyControllerPreventivoList');
         pageRef.setRedirect(true);
         return pageRef;
      }
  
  
  
  
  
  
    //Azione Update single record
    public PageReference save1() {
     for(Cliente__c r:preventivolist){
      String Id=r.Id;
         if(Id==idkeyclik ){
          update r;
        }
       }
       
    //Redirect after update to list page
    PageReference pageRef = new PageReference('/apex/MyControllerPreventivoList');
         pageRef.setRedirect(true);
         return pageRef;
       }
  

    
    //Azione Delete
    public PageReference cancella() {
       Cliente__c ric = [SELECT Id FROM Cliente__c WHERE Id=:idkeyclik LIMIT 1];
       delete ric;
        
    //Redirect after delete to list page
    PageReference pageRef = new PageReference('/apex/MyControllerPreventivoList');
         pageRef.setRedirect(true);
         return pageRef;
    }


}