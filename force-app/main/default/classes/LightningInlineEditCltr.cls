public with sharing class LightningInlineEditCltr {
    @AuraEnabled
    public static List < account > accountsToDisplay() {
        List < Account > returnList = new List < Account > ();
        List < Account > lstOfAccount = [select id, Name, Rating, website from account ];
        for (Account acc: lstOfAccount) {
            returnList.add(acc);
        }
        return returnList;
    }
    // method for update records after inline editing 
    @AuraEnabled
    public static List < account > saveAccount(List<Account> listOfAccount) {
        update listOfAccount;
        return listOfAccount;
    }
    // method for fetch picklist values dynamic 
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
}