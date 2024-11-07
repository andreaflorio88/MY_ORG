public class Riportafogliazione {

    @AuraEnabled(Cacheable=true)
    public static List<User> getUsers(){
        try {
            return [SELECT Id, Name FROM User WHERE isActive = true];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Account> getAccounts(String ownerId, String field, String sortOrder){
        try {
            String query;
            query  = 'SELECT Id, Name, AnnualRevenue FROM Account WHERE OwnerId =:ownerId';
            if(field != null && sortOrder !=null)
                query += ' ORDER BY '+field+' '+sortOrder;
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean tranferAccounts(String newOwnerId, List<Account> accounts, String closeDate, List<String> recordTypes, Boolean updateOpps){

        try {
            List<Opportunity> opps = new List<Opportunity>();

            for(Account acc: accounts)
                acc.OwnerId = newOwnerId;
            
            update accounts;

            if(updateOpps){
                String query = 'SELECT Id FROM Opportunity WHERE AccountId IN :accounts';

                if(recordTypes.size() > 0)      query += ' AND RecordTypeId IN :recordTypes';
                if(closeDate != 'Tutte')        query += ' AND isClosed = ' + (closeDate == 'Chiuse' ? 'true' : 'false'); 

                System.debug(query);
                for(Opportunity o: Database.query(query))
                    opps.add(new Opportunity(Id = o.Id , OwnerId = newOwnerId));

                update opps;
            }
            return true;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Opportunity> getOpps (String accId, String isClosed, List<String> retIds){

        String query = 'SELECT Id, Name, CloseDate, RecordType.Name, StageName, RecordTypeId FROM Opportunity WHERE AccountId = :accId ';
        query += isClosed == 'Tutte' ? '' : ( isClosed == 'Chiuse' ? ' AND isClosed = true' : ' AND isClosed = false' ) ;
        
        if(!retIds.isEmpty())
            query += ' AND RecordTypeId IN :retIds';
		

        return Database.query(query);
    }
}