global class BatchTest  implements Database.Batchable<sObject>, Schedulable  {

    public Integer batchSize = 2;
    private String query;
    
    
    public BatchTest(String aQuery) {
        query = aQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        // variabile di ritorno qloc
        Database.QueryLocator qloc;
        // verifico se nel costruttore ho inserito null oppure stringa vuota
        if(this.query==null || String.isBlank(this.query)){
        qloc = Database.getQueryLocator([select id from Account LIMIT 20]);
        } else{
                qloc =  Database.getQueryLocator(this.query);
            }
         return qloc;	
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        for(Account acc: scope) {
            acc.Name = 'TESTO';
            acc.Price__c = 1;
            update scope;
        }
        
    }  
    
    global void finish(Database.BatchableContext BC){}

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(this, batchSize);
    }

} 
// Per testarlo in Anonymous Window
// System.schedule('BatchTest', '0 35 * * * ?', new BatchTest(''));


/*
global class BatchTest implements Database.Batchable<sObject> {
    
    global final String query;
    global final String s_object;
    global final String field;
    global final String field_value;
    
    public BatchTest(String q, String s,String f, String v){
        query = q;
        s_object = s;
        field = f;
        field_value = v;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
         for(Sobject a : scope) {
             a.put(field,field_value);             
         }
         update scope;
    }  
    global void finish(Database.BatchableContext BC){}
    
}
*/