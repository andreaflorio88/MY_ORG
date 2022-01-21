public class WhatsAppController{

    public String message{get;set;}
    public Contact thisContact{get;set;}
    public Boolean showStatus{get;set;}
    public String statusMessage{get;set;}

    public WhatsAppController(ApexPages.StandardController controller){
        controller.addFields(new List<String>{'Phone'});
        this.thisContact = (Contact)controller.getRecord();
        showStatus = false;
        message='Hello '+thisContact.Name +',\n';
    }

    public void sendMessage(){
        if(message == null || message == ''){
            statusMessage ='Please enter some message';
            showStatus = true;
        }
        else{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res;

            req.setMethod('GET');
            req.setEndpoint('OPENSHIFT_URL_FOR_YOUR_FLASKAPP/sendmsg?to='+this.thisContact.Phone+'&msg='+EncodingUtil.urlEncode(message,'UTF-8')+'&token=<EXPECTED_TOKEN_THAT_YOU_SET_IN_FLASKAPP.PY>');
            res = http.send(req);
            message ='';
            statusMessage = 'Message Sent';
            showStatus = true;
            System.debug('\n\n---------- Response:' + res.getBody() + '\n\n');
        }
    }
}