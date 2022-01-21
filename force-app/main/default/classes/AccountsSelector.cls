public class AccountsSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Name, Account.Id, Account.Description, Account.AnnualRevenue
        };
    }
    
    public List<Schema.SObjectField> getAssetInformation(){
        return new List<Schema.SObjectField>{
            Account.Asset__c,
            Account.Asset__r.Name,
            Account.Asset__r.ParentId,
            Account.Asset__r.Product2.Name
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
    
    
    public List<Account> selectByIdWithAsset(Set<Id> idSet){
        fflib_SObjectSelector addressesSelector = new AccountsSelector();
        fflib_QueryFactory query = newQueryFactory()
                                   	.selectFields(getSObjectFieldList())
                                   	.selectFields(getAssetInformation())
            					   	.selectField('Asset__r.SerialNumber')
            						.selectField('Asset__r.Status')
                                   	.setCondition('Id IN :idSet');
        addressesSelector.configureQueryFactoryFields(query, 'Asset__r');
        addressesSelector.configureQueryFactoryFields(query, 'Asset__r.Product2');
        return (List<Account>) Database.query(query.toSOQL());
    }
    
    
    public List<Account> selectByIdWithAssets(Set<Id> idSet) {
      return (List<Account>) Database.query(
        newQueryFactory()
          .selectFields(getSObjectFieldList())
          .selectField(Account.Description)
          .setCondition('Id IN :idSet')
          //.setLimit(100)
          .toSOQL()
      );
    }
    
    public List<Account> selectByName(Set<String> names){
       fflib_QueryFactory query = newQueryFactory();
       query.addOrdering('Name', fflib_QueryFactory.SortOrder.ASCENDING);
       return (List<Account>) Database.query( query.toSOQL() );
	}
    
    public List<Account> selectByIdWithContacts(Set<Id> idSet) {
    	fflib_QueryFactory accountQueryFactory = 
        newQueryFactory()
          .selectFields(getSObjectFieldList())
          .selectField(Account.Email__c)
          .addOrdering('Name', fflib_QueryFactory.SortOrder.ASCENDING)
          .setCondition('Id IN :idSet');
            
        fflib_QueryFactory contactQueryFactory = accountQueryFactory.subselectQuery('Contacts')
            .selectField(Contact.LastName)
            .selectField(Contact.Phone)
            .addOrdering('Phone', fflib_QueryFactory.SortOrder.ASCENDING);
            //.setCondition(...)
            //.setLimit(1);
        fflib_QueryFactory assetQueryFactory = accountQueryFactory.subselectQuery('Assets')
            .selectField(Asset.Name)
            .addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
            //.setCondition(...)
            //.setLimit(1);
        
        return Database.query( accountQueryFactory.toSOQL());      
    }
    
    public override String getOrderBy(){
        return 'CreatedDate ASC';
    }
    
    public List<Account> selectById(Set<Id> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }
}