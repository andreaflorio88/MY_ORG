@RestResource(urlMapping='/CreateOneAccount/*')
global class WS_CreateOneAccountRecord {

    global class AccountParameters{
        global String name;
    }
 
    @HttpPost
    global static Map<String,String> createAccounts(AccountParameters accountParameters) {
        
        Map<String,String> result = new Map<String,String>();
        try {
            // RestRequest req = RestContext.request;
            // System.debug(req);
            // AccountParameters parameters = (AccountParameters)JSON.deserialize(req.requestBody.toString(), AccountParameters.Class);
            // result.put('OK', parameters.name);
            System.debug(accountParameters);
            result.put('OK', accountParameters.name);
        } catch(Exception ex){
            result.put('KO', ex.getMessage());
        }
        return result;
    }

    /*
    anziché inviare il semplice JSON {"name":"andrea"} e poi castare il JSON, invio direttamente il wrapper
        
        {
            "accountParameters": {
                "name":"andrea"
            }
        }

    */

    @HttpGet
    global static Account getAccountInfo() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        Account result =  [SELECT Id, Name, isActive__c, Age__c, Phone
                            FROM Account
                            WHERE Id = :accId];
        return result;

    }

    /*
    /services/apexrest/CreateOneAccount/<Record ID>
    */
}