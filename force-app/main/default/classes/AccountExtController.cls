public class AccountExtController {

    public Account acct;
    private ApexPages.StandardController stdController { get; set; }
    List<Account> accountList = new List<Account>();
    
    
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public AccountExtController(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        this.acct.OwnerId = UserInfo.getUserId();
        accountList.add(acct);
        
        
    }
    
    
        public PageReference salva() {
                if(acct.Price__c !=null) { 
        upsert accountList;
        PageReference page = Page.AccountDetail;//new Pagereference('/apex/AccountDetail?id=' + acct.Id);
        page.getParameters().put('id', acct.id);
        page.setRedirect(true);
                    return page; 
                }else if (acct.Price__c == null || acct.Price__c == 0){
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Price not valid');
                  ApexPages.addMessage(myMsg);
                  acct.Price__c.addError('Price not valid');
                }
                return null;
    }  
    
        public PageReference salvaNuovo() {
                if(acct.Price__c !=null){
            upsert accountlist;
        PageReference page = new Pagereference('/apex/AccountCustom');
            page.setRedirect(true);
            return page;
                }else if (acct.Price__c == null || acct.Price__c == 0){
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Price not valid');
                  ApexPages.addMessage(myMsg);
                  acct.Price__c.addError('Price not valid');
                }
                return null;
    }
    
        public PageReference cancella(){
        PageReference page = new Pagereference('/apex/AccountCustom');
            page.setRedirect(true);
            return page;
    }
    
       
}