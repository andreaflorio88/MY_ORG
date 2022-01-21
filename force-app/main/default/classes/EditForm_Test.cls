@isTest
public class EditForm_Test {
    
	private static testmethod void testEditRecord() {
        Account a = new Account(Name='test',phone='000',fax='000',email__c='a@test.com',price__c=3);
        insert a;
        EditForm.saveRecords(a.id, a.name, a.phone, a.fax, a.Email__c);
    }
        
}