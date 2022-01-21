/*
* @Author       : Biagio Calò (biagio.calo@accenture.com)
* @Created Date : 19/03/2019
* @Description  : Web service, used to verify if an Account exists and if he had a mail
* @Input        : ServiceInput : AccountId, Email
* @Output       : ServiceOutput : WebConsumer, errorCode, errorMessage
* @history      : 
*/

@RestResource(urlMapping='/verifyAccountEmail') 
global with sharing class WS_CheckEmailClassBiagio {

    global class Customer{               
        public String AccountId;
        public String Email;
        
    }
    
    global class VerifyMailResponse{
        public string WebConsumer;
        public string errorCode;
        public string errorMessage;
    }

    
    @HttpPost
    global static VerifyMailResponse verifyAccountEmail(Customer customer){
        System.debug('@@@START');   
        VerifyMailResponse response = new VerifyMailResponse();
        
        try{
            if(String.isBlank(customer.AccountId) || String.isBlank(customer.Email))
            {     
                //response.errorMessage = System.Label.AccountErrorMessage;
                response.errorCode = '400';
            } else {  
                boolean hasError = false;
                Account acc;
                try{
                    acc =  [SELECT Id, Email__c /*, WebConsumer__c */ FROM Account WHERE Id =: customer.AccountId LIMIT 1];
                    System.debug('@@@acc'+ acc);
                    
                    if (String.valueOf(acc.Email__c) == Customer.Email){
                        //acc.WebConsumer__c = true;
                        update acc;
                        response.WebConsumer = 'true';
                        response.errorCode = '00';
                    }
                    else
                    {
                        //response.errorMessage = System.Label.AccountEmailMismatch;
                        response.errorCode = '400';
                    }
                    
                }
                catch(Exception e)
                {
                    hasError = true;
                    response.errorcode = '402';
                    //response.errorMessage = System.Label.AccountNotFound;
                }
                // email account deve essere == a quella in input, se no errore.
                
                
                if ( ! hasError ){
                    //acc.WebConsumer__c = true;
                    update acc;
                    response.WebConsumer = 'true';
                    response.errorCode = '00';
                }
            }
            
        }
        catch(Exception e){
            system.debug(logginglevel.error, ' exception in verifyAccountEmail '+e.getMessage() +'at line '+e.getLineNumber() );
            response.errorcode = '999';
            response.errorMessage = 'Generic Error'; //System.Label.Error;
        }
        return  response;   
    }
    
}