@isTest
public class LogHandlerTest {

    @isTest
    public static void createLogTest(){
        try{
            throw new System.MathException();
        }
        catch(Exception e){
            LogHandler.createLog(e);
        }
        
        Log__c log = [SELECT Nome_Classe__c, Nome_Metodo__c, Tipo_Eccezione__c FROM Log__c LIMIT 1];
        
        system.assertEquals('LogHandlerTest', log.Nome_Classe__c);
        system.assertEquals('createLogTest', log.Nome_Metodo__c);
		system.assertEquals('System.MathException', log.Tipo_Eccezione__c);
    }
    
    @isTest
    public static void createLogNoteTest(){
        String request = 'Request';
        String response = 'Response';
        try{
            throw new System.CalloutException();
        }
        catch(Exception e){
            String note = 'Contenuto note';
            LogHandler.createLog(e, note);
        }
        
        Log__c log = [SELECT Nome_Classe__c, Nome_Metodo__c, Tipo_Eccezione__c, Note__c FROM Log__c LIMIT 1];
        
        system.assertEquals('LogHandlerTest', log.Nome_Classe__c);
        system.assertEquals('createLogNoteTest', log.Nome_Metodo__c);
		system.assertEquals('System.CalloutException', log.Tipo_Eccezione__c);
        system.assertEquals('Contenuto note', log.Note__c);
    }
    
    @isTest
    public static void createLogCalloutTest(){
        String request = 'Request';
        String response = 'Response';
        String note = 'Notes content';
        try{
            throw new System.CalloutException();
        }
        catch(Exception e){
            LogHandler.createLog(e, request, response);
            LogHandler.createLog(e, note, request, response);
        }
        
        List<Log__c> logs = [SELECT Nome_Classe__c, Nome_Metodo__c, Tipo_Eccezione__c, Note__c FROM Log__c ORDER BY NAME ASC];
        Log__c log = logs[0];
        Log__c logWithNotes = logs[1];
        system.assertEquals('LogHandlerTest', log.Nome_Classe__c);
        system.assertEquals('createLogCalloutTest', log.Nome_Metodo__c);
		system.assertEquals('System.CalloutException', log.Tipo_Eccezione__c);
        system.assertEquals(null, log.Note__c);
        
        system.assertEquals('LogHandlerTest', logWithNotes.Nome_Classe__c);
        system.assertEquals('createLogCalloutTest', logWithNotes.Nome_Metodo__c);
		system.assertEquals('System.CalloutException', logWithNotes.Tipo_Eccezione__c);
        system.assertEquals('Notes content', logWithNotes.Note__c);
    }
    
    @isTest
    public static void createInfoLogTest(){
        String note ='note test';
        String response = 'response test';
        String request = 'request test';
        LogHandler.createLog(note);
        LogHandler.createLog(note,request,response);
        LogHandler.createLog(request,response);
        
        //first created log is first element of list queried list
        Log__c[] logList = [SELECT Nome_Classe__c, Nome_Metodo__c, Tipo_Eccezione__c, Note__c, Tipologia_Log__c,Messaggio_Errore__c,
                            Request__c, Response__c FROM Log__c Order By Name ASC];
        
        
        system.assertEquals('note test', logList[0].Note__c);
        system.assertEquals('Info', logList[0].Tipologia_Log__c);
        system.assertEquals('createInfoLogTest', logList[0].Nome_Metodo__c);
        system.assertEquals('LogHandlerTest', logList[0].Nome_Classe__c);
        system.assertEquals(null, logList[0].Tipo_Eccezione__c);
        system.assertEquals(null, logList[0].Messaggio_Errore__c);
        
        
        system.assertEquals('note test', logList[1].Note__c);
        system.assertEquals('request test', logList[1].Request__c);
        system.assertEquals('response test', logList[1].Response__c);
        system.assertEquals('Info', logList[1].Tipologia_Log__c);
        system.assertEquals('createInfoLogTest', logList[1].Nome_Metodo__c);
        system.assertEquals('LogHandlerTest', logList[1].Nome_Classe__c);
        system.assertEquals(null, logList[1].Tipo_Eccezione__c);
        system.assertEquals(null, logList[1].Messaggio_Errore__c);

        
        system.assertEquals('request test', logList[2].Request__c);
        system.assertEquals('response test', logList[2].Response__c);
        system.assertEquals('Info', logList[2].Tipologia_Log__c);
        system.assertEquals('createInfoLogTest', logList[2].Nome_Metodo__c);
        system.assertEquals('LogHandlerTest', logList[2].Nome_Classe__c);
        system.assertEquals(null, logList[2].Tipo_Eccezione__c);
        system.assertEquals(null, logList[2].Messaggio_Errore__c);

    }
    
    @isTest
    public static void logDatabaseResult(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Account 1'));
        accounts.add(new Account(Name='Account 2'));
        List<Database.UpsertResult> results = Database.upsert(accounts);
        LogHandler.createLog(results);
    }
}