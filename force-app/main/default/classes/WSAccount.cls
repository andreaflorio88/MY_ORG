@RestResource(urlMapping='/CreateAccount/*')
global class WSAccount {
    
    global class Request {
        global List<DetailsAccount> account{get;set;} 
    }
    // FIELD TO INSERT IN CALL
    global class DetailsAccount{    
        global String Name			{get;set;}
        global String Phone			{get;set;}
        global String ExternalId	{get;set;}
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
    global static Response createCase(Request request) {
        Response response = new response();
        try {
            List<DetailsAccount> accToInsert = new List<DetailsAccount>();
            set<String> setName = new Set<String>();
            set<String> setPhone = new Set<String>();
            set<String> setExternalId = new Set<String>();
            for(DetailsAccount  dp : request.account){
                if (String.isBlank(dp.Name) || String.isBlank(dp.Phone)) {
                    response.hasError = true;
                    Map<String,String> mapError = New Map<String,String>();
                    // CHECK NAME
                    if(String.isBlank(dp.Name)){
                        mapError.put('resultMessage','Name mandatory field');
                        mapError.put('ERROR','ERROR');    
                        // CHECK PHONE
                    } else if(String.isBlank(dp.Phone)) {
                        mapError.put('resultMessage','Phone mandatory field');
                        mapError.put('ERROR','ERROR');
                    } else if(String.isBlank(dp.ExternalId)) {
                        mapError.put('resultMessage','ExternalId mandatory field');
                        mapError.put('ERROR','ERROR');
                    }  response.responses.add(mapError);
                } else {
                    response.hasError = false;
                    setName.add(dp.Name);
                    setPhone.add(dp.Phone);
                    setExternalId.add(dp.ExternalId);
                    System.debug('@@@setExternalId '+ setExternalId);
                    accToInsert.add(dp);
                    System.debug('@@@'+ accToInsert);
                }
            }
            // bulk insert
            List<Account> accListToInsert = new List<Account>(); 
            List<Account> accListToUpdate = new List<Account>();
            Account a;
            Map<String,String> mapSuccess = New Map<String,String>();
            List<Account> accToUpdateByExtId = [Select Id, ExternalId__c from Account where ExternalId__c IN: setExternalId];
            // MAP K(ID) V(ACCOUNT)
            //Map<Id, Account> externalIdToAccountMap = new Map<Id,Account>([Select Id, ExternalId__c from Account where ExternalId__c IN: setExternalId]);
            //System.debug('@@@externalIdToAccountMap '+ externalIdToAccountMap);
            for(DetailsAccount  dp : accToInsert){
                if(!accToUpdateByExtId.isEmpty()){
                    for(Account acc : accToUpdateByExtId){
                        if(acc.ExternalId__c.equals(dp.ExternalId)){
                            System.debug('@@@DUPLICATE VALUE: ' + acc.Id);
                            a.Id = acc.Id;
                            a.Name = dp.Name;
                            a.Phone = dp.Phone;
                    		a.ExternalId__c = dp.ExternalId;
                            accListToUpdate.add(a);
                        }
                    }
                } else {
                    Account b = new Account();
                    b.Name = dp.Name;
                    b.Phone = dp.Phone;
                    b.ExternalId__c = dp.ExternalId;
                    accListToInsert.add(b);  
                }
            }
            
            if(!accListToInsert.isEmpty()){
                insert accListToInsert;
                createResponseList(accListToInsert,mapSuccess,response);
            }
            
        }catch(Exception ex){
            Map<String,String> mapError = New Map<String,String>();
            response.hasError = true;
            mapError.put('result','FAILED');
            mapError.put('resultMessage','Catched System Error :'+ex.getMessage());
            response.responses.add(mapError);
            
        }
        return response; 
    }
    
    public static void createResponseList(List<Account> accListToInsert, Map<String,String> mapSuccess, Response response) {
        for (Account acc : accListToInsert){
            mapSuccess.put('resultMessage','Id: ' + acc.Id);
            mapSuccess.put('SUCCESS','SUCCESS');
            response.responses.add(mapSuccess);  
        }
    }
    
   
}


/*
/services/apexrest/CreateAccount/*

{"request":{ "account": [{
"name" : "",
"phone" : ""
}]}}
*/