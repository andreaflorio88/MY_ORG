@RestResource(urlMapping='/secureApexRest/*')
global with sharing class SecureApexRest {
    @HttpGet
    global static Contact doGet(){
        RestRequest req = RestContext.request;
        String recordId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact result;
        if (recordId == null){
            throw new FunctionalException('Id parameter is required');
        }
        List<Contact> results;
        // exception
        if(!Schema.SObjectType.Contact.fields.Secret_Key__c.isAccessible()){
            throw new SecurityException('You don\'t have access to all contact fields required to use this API');
        } else {
            results = [SELECT id, Name, Secret_Key__c FROM Contact WHERE Id = :recordId WITH SECURITY_ENFORCED];        
        	if (!results.isEmpty()) {
                result = results[0];
        	} 
        } 
        return result;
    }
    public class FunctionalException extends Exception{}
    public class SecurityException extends Exception{}



}