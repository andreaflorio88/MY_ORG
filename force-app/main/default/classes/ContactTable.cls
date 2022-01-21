public class ContactTable {
	@AuraEnabled
    public static List<Contact> getContacts(Id recordId) {
        List<Contact> con = [SELECT Id,FirstName,LastName,Email, Phone FROM Contact WHERE AccountId = :recordId];
        //system.debug('contacts list' + con);
		return con;
    }
    
    
	@AuraEnabled
	public static List <Contact> updateContact(List<Contact> editedContactList) {
            for(Integer index=0; index<editedContactList.size(); index++){
                //if(editedContactList[index].FirstName != null){ 	
                    update editedContactList;
                
            } 
        update editedContactList;
        return editedContactList;
    	
    }
    
    @AuraEnabled
    public static List<Contact> up(List<Contact> inputC){
        	for(Contact con : inputC){
               
        		update inputC;   
        }
        update inputC;
        return inputC;
    }
    
}