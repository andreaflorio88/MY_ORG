/*
* --- USAGE ---
* createLog(Exception e)
*   Inserisce a database un nuovo record Log__c con tutti i campi autopopolati. 
*   Paramentro opzionale note può essere utilizzato per inserire informazioni a piacere (massimo 32768 caratteri) 
*/
public class LogHandler {
    private final static Integer MAXLENGTH = 32768;
    private final static String exceptionLogType = 'Eccezione';
    private final static String infoLogType = 'Info';

    public static void createLog(Exception e){
        initializeLog(e, '', '', '',exceptionLogType);
    }

    public static void createLog(Exception e, String note){
        initializeLog(e, note, '', '',exceptionLogType);
    }

    public static void createLog(Exception e, String note, String request, String response){
        initializeLog(e, note, request, response,exceptionLogType);
    }

    public static void createLog(Exception e,String request, String response){
        initializeLog(e, '', request, response,exceptionLogType);
    }

    public static void createLog(String note){
        initializeInfoLog(note, '', '');
    }

    public static void createLog(String request, String response){
        initializeInfoLog('', request, response);
    }

    public static void createLog(String note, String request, String response){
        initializeInfoLog(note, request, response);
    }

    public static void createLog(List<Object> databaseResults){
        List<String> databaseErrors = new List<String>();
        List<DatabaseGenericResult> results = DatabaseGenericResult.resultsToGenericResults(databaseResults);

        for(DatabaseGenericResult res: results)
            if(!res.isSuccess())
                databaseErrors.add(String.valueOf(res.getErrors()));

        if(!databaseErrors.isEmpty())
            initializeInfoLog(String.valueOf(databaseErrors),'','');
    }

    private static void initializeInfoLog(String note, String request, String response){
        try{//exception type doesn't really matter, we just need a stack trace
            throw new MathException('');
        }
        catch(Exception e){
            initializeLog(e, note, request, response,infoLogType);
        }
    }


    //initializes all the record fields
    private static void initializeLog(Exception e,String note, String request, String response,String logType){
        String className;
        String methodName;

        List<String> namingInfo = extractNamingInfo(e);
        className = namingInfo.get(0);
        methodName = namingInfo.get(1);

        Log__c log = new Log__c(Utente__c = UserInfo.getUserId(),
                Data__c = System.now(),
                Messaggio_Errore__c = e.getMessage(),
                Tipo_Eccezione__c = logType == exceptionLogType ? e.getTypeName() : null,
                Riga_Errore__c = String.valueOf(e.getLineNumber()),
                Stack_Trace__c = e.getStackTraceString(),
                Nome_Classe__c = className,
                Nome_Metodo__c = methodName,
                Tipologia_Log__c = LogType,
                Note__c = note.abbreviate(MAXLENGTH),
                Request__c = request.abbreviate(MAXLENGTH),
                Response__c = response.abbreviate(MAXLENGTH));
        insert log;
    }

    //returns a List of Strings where the first one is the className and the second one is the methodName
    private static List<String> extractNamingInfo(Exception e){
        String mainLine;


        List<String> traces = e.getStackTraceString().split('\n');
        for(String trace : traces){
            if(!trace.contains('Class.LogHandler.')){
                //first trace not containing 'Class.LogHandler.' string is the original class/method we are interested in
                mainLine = trace;
                break;
            }
        }

        /*if(logType == exceptionLogType){
            mainLine = e.getStackTraceString().split('\n').get(0); //get first line
        }
        else if(logType == infoLogType){
            //mainLine = e.getStackTraceString().split('\n').get(2); //get third line (we need the original class caller)
            List<String> traces = e.getStackTraceString().split('\n');
            system.debug(traces);
            for(String trace : traces){
                if(!trace.contains('Class.LogHandler.')){
                    //first trace not containing LogHandler class name is the original class/method we are interested in
                    mainLine = trace;
                    break;
                }
            }
        }*/

        System.debug(mainLine);

        List<String> namingInfo = mainLine.left(mainLine.indexOf(':')).split('\\.');
        if(namingInfo.size()>1){
            //classica stringa di stackTrace Class.nomeClasse.nomeMetodo
            namingInfo.remove(0); //remove 'Class' string;
        }
        else{
            /* stackTrace strano, metto questo pezzo per evitare che il codice si spacchi se mai si dovesse ottenere uno stackTrace del genere.
             * Se qualcuno riesce a ottenere un caso del genere me lo faccia sapere (per ora sono riuscito ad ottenerlo solo tramite
             * codice eseguito come anonymous block, che però è un caso particolare e out of scope per l' utilizzo dell' oggetto Log__c)
             */
            return  new List<String>(2);
        }
        return namingInfo;
    }

    public static Log__c collectLogCallout(String chiave, String className, Object request, Object response,
            Boolean state, Object errorMessage, String evento){

        return new Log__c(Utente__c = UserInfo.getUserId(),
                Data__c = System.now(),
                Messaggio_Errore__c = String.valueOf(errorMessage),
                Request__c = request != null ? String.valueOf(request).abbreviate(MAXLENGTH) : '',
                Response__c = response != null? String.valueOf(response).abbreviate(MAXLENGTH) : '',
                Key__c = chiave,
                Nome_Classe__c = className,
                Log_CAI__c = true,
                Esito__c = state ? 'Success' : 'Failure',
                Evento__c = evento);

    }

    public static void createLogCallout(String chiave, String className, Object request, Object response,
            Boolean state, Object errorMessage, String evento){

        Log__c log = new Log__c(Utente__c = UserInfo.getUserId(),
                Data__c = System.now(),
                Messaggio_Errore__c = String.valueOf(errorMessage),
                Request__c = request != null ? String.valueOf(request).abbreviate(MAXLENGTH) : '',
                Response__c = response != null? String.valueOf(response).abbreviate(MAXLENGTH) : '',
                Key__c = chiave,
                Nome_Classe__c = className,
                Log_CAI__c = true,
                Esito__c = state ? 'Success' : 'Failure',
                Evento__c = evento);
        try{

            insert log;


        }catch(Exception e){

            System.debug(e);
        }

    }
}