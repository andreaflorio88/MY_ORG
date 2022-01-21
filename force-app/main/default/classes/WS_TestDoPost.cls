/**
* Author        : Andrea Florio
* Created       : 2019-05-13
* Description   : Create Peron account REST Service for PRONTO
* Test Class    : WS_CreateAccountFromDL_Pronto
**/
@RestResource (urlMapping = '/DoPost/*' )
global class WS_TestDoPost{
    
    global class Response {
        global List<Map<String,String>> responses;
        global Boolean hasError{get;Set;}
        
        public Response(){
            hasError = false;
            responses = new List<Map<String,String>>();
        }   
    }
    
    @httpPost
    global static Response createUserService(String test, String test2, Boolean test3) {
        Response response = new Response();
        try {
            if(!String.isBlank(test)){
               Map<String,String> successResponse = new Map<String,String>();
               successResponse.put('OK', test);
            	response.responses.add(successResponse);
            }
        } catch(Exception ex){
            Map<String,String> errorResponseMap = new Map<String,String>();
            response.hasError = true;
            errorResponseMap.put('result','FAILED');
            errorResponseMap.put('id','');
            errorResponseMap.put('operationType','Catched System Error');
            errorResponseMap.put('resultMessage','Catched System Error: '+ex.getMessage());
            response.responses.add(errorResponseMap);
        }
        return response;
    }


    /*
    /services/apexrest/DoPost
    {
        "test":"t",
        "test2":"y",
        "test3":false
	}
    */
}