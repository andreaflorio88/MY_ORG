public class ContactSearch {
	
    public static List<Contact> searchForContacts(String lastName, String mailingPostalCode){
        
        return [SELECT FIELDS(Standard) FROM Contact WHERE LastName =:lastName AND MailingPostalCode =:mailingPostalCode];
    }
}