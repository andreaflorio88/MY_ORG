public class AccountDetailController {
    public Account det{get;set;}
    private ApexPages.StandardController stdController { get; set; }
    List<Account> lista = new List<Account>();
    
    
    
    public AccountDetailController(ApexPages.StandardController stdController) {
        this.det = (Account)stdController.getRecord();
        this.det.OwnerId = UserInfo.getUserId();
        lista.add(det);
    }
    
    public PageReference modifica() {
        PageReference page = new Pagereference('/apex/AccountCustom?id=' + det.Id);
        page.setRedirect(true);
        return page;
      
    }
    
    public PageReference salva() {
        upsert lista;
    PageReference page = new Pagereference('/apex/accountdetail?id=' + det.id);
        page.setRedirect(true);
        return page;
    }
    
    public PageReference cancella(){
    PageReference page = new Pagereference('/apex/accountdetail?id=' + det.id);
    page.setRedirect(true);
    return page;
    }
    
}