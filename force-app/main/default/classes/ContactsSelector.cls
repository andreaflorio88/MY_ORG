public class ContactsSelector extends fflib_SObjectSelector {
	
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Contact.Name
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return Contact.sObjectType;
    }
    
}