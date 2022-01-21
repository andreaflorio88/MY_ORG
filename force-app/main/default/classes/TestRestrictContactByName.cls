@isTest
public class TestRestrictContactByName {
   public static testmethod void verifyContact()
    {   
        Contact c = new Contact();
        c.LastName = 'INVALIDNAME';
        insert c;
    }
}