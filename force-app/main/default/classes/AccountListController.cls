public class AccountListController {
    
    @AuraEnabled
    public static List <Event> eventList() {
        return [ SELECT Id, Subject, StartDateTime, EndDateTime FROM Event];
    }
    
}