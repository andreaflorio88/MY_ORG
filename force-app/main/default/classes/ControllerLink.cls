public class ControllerLink {
    public class WrapperSurvey {
        public String Id {get;set;}
        public String tod {get;set;}
    	}
    
    @AuraEnabled
    public static String getParameter(id accountId){ 
        WrapperSurvey wrap = new WrapperSurvey();
        // Take AccountId
        List<Account> accList =  [SELECT Id FROM Account WHERE Id=:accountId];
        if(!accList.isEmpty()){
            String acId = accList.get(0).Id;
            Blob beforeblob = Blob.valueOf(acId);
            wrap.Id = EncodingUtil.base64Encode(beforeblob);
            wrap.tod = String.valueOf(Date.today()).replace('-','');
        }
    System.debug('@@ wrap' + wrap.Id);
        return JSON.serialize(wrap);
    }
    
}