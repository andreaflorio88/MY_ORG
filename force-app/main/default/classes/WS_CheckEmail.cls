@RestResource(urlMapping='/verifyAccountEmail/*')
global class WS_CheckEmail {
    
    global class Request {
        global List<DetailsAccount> account{get;set;} 
    }
    // FIELD TO INSERT IN CALL
    global class DetailsAccount{    
        global String Email	{get;set;}
        global Id AccountId {get;set;}
    }
    
    global class Response {
        global List<Map<String,String>> responses{get;Set;}
        global Boolean hasError{get;Set;}
        
        public Response(){
            hasError = false;
            responses = new List<Map<String,String>>();
        }
    }
    
    @HttpPost
    global static Response verifyAccountEmail(Request request){
        Response response = new response();
        try {
            Map<String,String> mapError = New Map<String,String>();
            set<String> setAccountId = new Set<String>();
            for(DetailsAccount  dp : request.account){
                if (String.isBlank(dp.Email) || String.isBlank(dp.AccountId)) {
                    response.hasError = true;
                    if (String.isBlank(dp.AccountId) || dp.AccountId == null) { 
                        mapError.put('resultMessage','AccountId non presente');
                        mapError.put('ERROR','errorCode 400');
                        system.debug('@@@ACCOUNTID:'+ dp.AccountId);
                    } else if (String.isBlank(dp.Email)){
                        mapError.put('resultMessage','Email non presente');
                        mapError.put('ERROR','errorCode 400'); 
                        system.debug('@@@EMAIL:'+ dp.Email);
                    }
                    response.responses.add(mapError);
                }else {
                    response.hasError = false;
                    setAccountId.add(dp.AccountId);
                    System.debug('@@@setAccountId: '+ setAccountId);
                    List<Account> accToUCheckEmail = [Select Id, Email__c from Account where Id =: setAccountId];
                    System.debug('@@@accToUCheckEmail: ' + accToUCheckEmail);
                    if(accToUCheckEmail.isEmpty()){
                        response.hasError = true;
                        mapError.put('resultMessage','Account not exist');
                        mapError.put('ERROR','ERROR'); 
                    } else {
                        response.hasError = true;
                        mapError.put('resultMessage','Account exist on SFDC');
                        mapError.put('SUCCESS','SUCCESS');  
                    }
                    response.responses.add(mapError);
                }
            }
            
        } catch (Exception ex) {
            Map<String,String> mapError = New Map<String,String>();
            response.hasError = true;
            mapError.put('result','FAILED');
            mapError.put('resultMessage','Catched System Error :'+ex.getMessage());
            response.responses.add(mapError); 
        }
        return response;
    }
}

/*
{"request":{ "account": [{
"AccountId": "0010N00004r8vcO",
"Email" : "a@gmail.com"
}]}}*/