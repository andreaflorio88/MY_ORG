/*
 Source : sfdcMonkey.com
 Date : 3/13/2019
 API : 45.00
*/
public class LightningDataTableController {
    /*apex method to fetch account list*/
    @AuraEnabled
    public static List <Account> getAccounts() {
        List<Account> accountList = new List<Account>();
        for(Account Acc : [SELECT  Id, Name, Email__c, Type FROM Account WHERE Name LIKE '%Andrea%' LIMIT 5]){
            accountList.add(Acc);
        }
        return accountList;
    }
}