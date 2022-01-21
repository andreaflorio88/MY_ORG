public class DatabaseGenericResult {
    final Boolean isSuccess;
    final Database.Error[] errors;
    
    public Boolean isSuccess(){
        return isSuccess;
    }
    public Database.Error[] getErrors(){
        return errors;
    }
    
    public DatabaseGenericResult(Database.SaveResult result){
        this.isSuccess = result.isSuccess();
        this.errors = result.errors;
    }
    public DatabaseGenericResult(Database.UpsertResult result){
        this.isSuccess = result.isSuccess();
        this.errors = result.errors;
    }
    public DatabaseGenericResult(Database.DeleteResult result){
        this.isSuccess = result.isSuccess();
        this.errors = result.errors;
    }
    public DatabaseGenericResult(Database.UndeleteResult result){
        this.isSuccess = result.isSuccess();
        this.errors = result.errors;
    }
    
    public static DatabaseGenericResult[] resultsToGenericResults(List<Object> results){
        
        List<DatabaseGenericResult> genericResults = new List<DatabaseGenericResult>();
       //non c'è una classe padre disponibile quindi non posso sfruttare il polimorfismo. Proprio object oriented sto linguaggio eh...
        if(results instanceof List<Database.SaveResult>){
            for(Database.SaveResult res :(List<Database.SaveResult>)results)
                genericResults.add(new DatabaseGenericResult(res));
        }
            
        else if(results instanceof List<Database.UpsertResult>){
            for(Database.UpsertResult res :(List<Database.UpsertResult>)results)
                genericResults.add(new DatabaseGenericResult(res));
        }
            
        else if(results instanceof List<Database.DeleteResult>){
            for(Database.DeleteResult res :(List<Database.DeleteResult>)results)
                genericResults.add(new DatabaseGenericResult(res));
        }
          
        else if(results instanceof List<Database.UndeleteResult>){
            for(Database.UndeleteResult res :(List<Database.UndeleteResult>)results)
                genericResults.add(new DatabaseGenericResult(res));
        }
        return genericResults;
    }
    
}