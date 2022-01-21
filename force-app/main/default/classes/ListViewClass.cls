public class ListViewClass {
@AuraEnabled
    public static List<ListView> getListView(Id recordId) {
        List<ListView> lv = [SELECT DeveloperName, SObjectType FROM ListView where SObjectType =: recordId ];
        return lv;
    }
}