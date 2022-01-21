public class EditForm {
    
    @AuraEnabled
    public static void saveRecords(String accountId, String name, String phone, string fax, String email,String type,String asset) {
    	Account acc = [select id,Phone,Fax,Email__c from Account where id =: accountId];
        acc.Name = name;
        acc.Phone = phone;
        acc.Fax = fax;
        acc.Email__c = email;
        acc.Type = type;
        acc.Asset__c = asset;
        update acc;
        
    }
}