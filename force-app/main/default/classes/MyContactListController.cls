public class MyContactListController {
@AuraEnabled
    public static List<Contact> getContacts(Id recordId) {
        List<Contact> cs = [SELECT Id,FirstName,LastName,Email,Phone FROM Contact WHERE AccountId = :recordId ];
        return cs;
    }
}