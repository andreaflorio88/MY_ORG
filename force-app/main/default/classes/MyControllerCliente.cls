public class MyControllerCliente {

    private final Cliente__c cliente;
    
    public MyControllerCliente () {
        Id id = ApexPages.currentPage().getParameters().get('id');
        cliente = (id == null) ? new Cliente__c () : 
            [SELECT Id, Name, Nome__c, Indirizzo__c, Telefono__c,  Cognome__c, Data_Nascita__c FROM Cliente__c WHERE Id = :id];
    }
  
    public Cliente__c  getCliente() {
        return cliente;
    }
    
    
    
    //Azione Insert
    public PageReference nuovo() {
        insert cliente;
    return null;
    
    //ridirect
    //PageReference pageRef = new PageReference('Cliente__c');
    //return pageRef;
    
    }
    
    //Azione Update
    //public PageReference aggiorna() {
    //    update cliente;
 
    //ridirect
    //PageReference pageRef = new PageReference('/apex/custom_page');
    //return pageRef;
 
    //}
    
    
    
    //Azione Go to List
    //public PageReference go() {

    //ridirect
    //PageReference pageRef = new PageReference('/apex/custom_page');
    //return pageRef;
    //}
    
}