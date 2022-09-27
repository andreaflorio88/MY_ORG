public with sharing class LWCDataTableSortingExample {
    @AuraEnabled(Cacheable=true)
    public static List <Contact> getContacts(String field, String sortOrder) {
        String query;
        query  = 'SELECT Id, FirstName, LastName, Phone, Email FROM Contact';
        if(field != null && sortOrder !=null){
            query += ' ORDER BY '+field+' '+sortOrder;
        }
        return Database.query(query);
    }
}