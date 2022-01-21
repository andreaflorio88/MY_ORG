public with sharing class inlineEditCtrl {
  
    // method for fetch account records list  
    @AuraEnabled
    public static List < account > fetchAccount() {
        
        List < Account > returnList = new List < Account > ();
        List < Account > lstOfAccount = [select id, Name, Rating, website from account LIMIT 5];
        
        for (Account acc: lstOfAccount) {
            returnList.add(acc);
        }
        return returnList;
    }
    
  // method for update records after inline editing  
    @AuraEnabled
    public static List < account > saveAccount(List<Account> lstAccount) {
        update lstAccount;
        return lstAccount;
    }
    
  // method for fetch picklist values dynamic  
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
}