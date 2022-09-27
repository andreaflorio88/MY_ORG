public class ValidateIT_CS_Token {

    public class ResponseException extends Exception {}

    // @InvocableMethod(label = 'Invoke Service')
    public static Boolean IT_CS_TokenValidation(String TranscriptId){

        Boolean isValid = false;

        //String token = [SELECT IT_CS_Token__c FROM LiveChatTranscript WHERE Id =: TranscriptId LIMIT 1]?.IT_CS_Token__c;
        
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HttpResponse();

        String tokenLoginRCI = getTokenFromLoginRCI();
    
        req.setMethod('GET');
        req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/JWTToken/?token='+ tokenLoginRCI);
        req.setHeader('Authorization', 'Bearer' + getTokenFromAuthToken(tokenLoginRCI));

        try {
            Http http = new Http();
            res = http.send(req);
            System.debug('Response Body: ' + res.getBody());
            System.debug('Response Status code: ' + res.getStatusCode());
            if(res.getStatusCode() == 200){
                Map<String,Object> m = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                isValid = (Boolean)m.get('isValid');
            }
            else {
                // da gestire l'errore
                throw new ResponseException('status code: '+ res.getStatusCode());
            }
        }
        catch (Exception e) {
            System.debug('Error in callout: ' + e.getMessage());
            System.debug('Error trace: ' + e.getStackTraceString());
        }

        return isValid;
    }

    private static String getTokenFromLoginRCI(){
        String result = '';

        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HttpResponse();

        String username = 'd.iacobelli@gunpowder.eu.sandboxrci';
        String password = 'RCIbanque21!!!';
        String client_id = '3MVG9Lu3LaaTCEgJ1gvddPIi1T8qucr_kbI4KCjJco4C0ohrMbgTxhXUtQUWPeqza5WgrIztrQfO5Uhod7.MQ';
        String client_secret = '0567833590E221B7FFE8EE478776E4D9E771BC6510088AE5899B975851F1D1C1';

        req.setMethod('POST');
        req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/oauth2/token?'+
                        'password='+ password + '&username='+ username + '&grant_type=password'+ 
                        '&client_id='+client_id + '&client_secret='+ client_secret);

        try {
            Http http = new Http();
            res = http.send(req);
            System.debug('Response Body: ' + res.getBody());
            System.debug('Response Status code: ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
                Map<String,Object> m = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                result = (String)m.get('access_token');
            }
            else {
                // da gestire l'errore
                throw new ResponseException('status code: '+ res.getStatusCode());
            }
        } 
        catch (Exception e) {
            System.debug(e);
        }

        return result;
    }

    private static String getTokenFromAuthToken(String tokenLoginRCI){
        String result = '';

        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HttpResponse();

        req.setMethod('POST');
        req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/JWTToken/');
        req.setHeader('Authorization', 'Bearer' + getTokenFromAuthToken(tokenLoginRCI));

        req.setBody('{"customerId":"0013N00000ZCMGxQAP"}');
        
        try {
            Http http = new Http();
            res = http.send(req);
            System.debug('Response Body: ' + res.getBody());
            System.debug('Response Status code: ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
                Map<String,Object> m = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                result = (String)m.get('token');
            }
            else {
                // da gestire l'errore
                throw new ResponseException('status code: '+ res.getStatusCode());
            }
        } 
        catch (Exception e) {
            System.debug(e);
        }

        return result;
    }

}