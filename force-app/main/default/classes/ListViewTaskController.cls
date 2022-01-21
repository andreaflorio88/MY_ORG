public class ListViewTaskController {
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Activity' ];
        return listviews;
    }
}