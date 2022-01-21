trigger AssetCount on Asset (after update) {
    
    //new AssetTriggerHandler().run();
    
        
        Map<Id,Asset> assetNewMap = (Map<Id,Asset>)Trigger.NewMap;
        Map<Id,Asset> assetOldMap = (Map<Id,Asset>)Trigger.OldMap;
        Set<Id> accountIdSet = new Set<Id>(); 
        System.debug('@@@MAP: '+ assetNewMap );
        for(Id AssetId : assetNewMap.keySet()){
            if(!(assetNewMap.get(AssetId).Status).equals(assetOldMap.get(AssetId).Status)){ 
                if((assetOldMap.get(AssetId).Status).equals('Unlinked') && (assetNewMap.get(AssetId).Status).equals('Active')){
                    accountIdSet.add(assetNewMap.get(AssetId).AccountId);
                    System.debug('@@@accountIdSet: '+ accountIdSet );
                }
                if((assetOldMap.get(AssetId).Status).equals('Active') && ((assetNewMap.get(AssetID).Status).equals('Returned') || (assetNewMap.get(AssetID).Status).equals('Returned'))){
                    accountIdSet.add(assetNewMap.get(AssetId).AccountId);
                    System.debug('@@@accountIdSet: '+ accountIdSet );
                }
            }      
        }
        
        if(!accountIdSet.isEmpty()){
            List<Account> accountToUpdate = [Select id, Device__c, (SELECT Id FROM Assets WHERE Status = 'Active' AND ParentId = null) from Account where id IN :accountIdSet];
            if(!accountToUpdate.isEmpty()){
                accountToProcess(accountToUpdate);
            }
        }
    
       
    public static void accountToProcess(List<Account> accToProcess){
        for(Account anAcc : accToProcess) {
            anAcc.Device__c = (anAcc.Assets != null ? anAcc.Assets.size() : 0);
            System.debug('@@@anAcc.Device__c: '+ anAcc.Device__c );
        }
        update accToProcess;
    }
    
}
    



/*
Map<Id, List<Asset>> AcctAssetList = new Map<Id, List<Asset>>();
Set<Id> AcctIds = new Set<Id>();   
List<Account> AcctList = new List<Account>();
List<Asset> AssList = new List<Asset>();
if(trigger.isInsert || trigger.isUPdate) {
for(Asset Ass : trigger.New) {
if(String.isNotBlank(Ass.AccountId)){
AcctIds.add(Ass.AccountId); 
}  
} 
}
if(trigger.isDelete || trigger.isUPdate) {
for(Asset Ass : trigger.Old) {
AcctIds.add(Ass.AccountId);    
} 
}          
if(AcctIds.size() > 0){
AssList = [SELECT Id, AccountId FROM Asset WHERE AccountId IN : AcctIds];
for(Asset Ass : AssList) {
if(!AcctAssetList.containsKey(Ass.AccountId)){
AcctAssetList.put(Ass.AccountId, new List<Asset>());
}

AcctAssetList.get(Ass.AccountId).add(Ass);   
}                          
System.debug('Account Id and Asset List Map is ' + AcctAssetList);
AcctList = [SELECT Device__c FROM Account WHERE Id IN : AcctIds];
System.debug('@!@ AcctList' + AcctList);

for(Account Acc : AcctList) {
List<Asset> AssList = new List<Asset>();
if(AcctAssetList.get(Acc.Id)== null) {
Acc.Device__c = 0;
} else {
AssList = AcctAssetList.get(Acc.Id);
Acc.Device__c= AssList.size();
}
}  


System.debug('Account List is ' + AcctList);
update AcctList; 
}

}



trigger UpdateFieldAccount on Asset (before Update) {

List<Account> accList = new List<Account>();
//List<Asset> assList = new List<Asset>();
//TODO: ADD WHERE CLAUSE
List<Asset> assList = [Select id, AccountId, Account.Device__c FROM Asset];

for(Asset assOld: Trigger.Old) {
for (Asset AssNew: Trigger.New) {
//TODO: ADD OTHER IF CLAUSE
if(!AssOld.AccountId.equals(AssNew.AccountId)) {
System.debug('£££ UPDATE ACCOUNTID STARTED');
System.debug('£ OLD ACCOUNTID: '+AssOld.AccountId);
System.debug('£ NEW ACCOUNTID: '+AssNew.AccountId);

// Decrement
Asset ass = new Asset();
ass.Id = AssOld.Id;
ass.AccountId = AssOld.AccountId;
ass.ParentId = AssOld.ParentId;
AssList.add(ass);
System.debug('£ ASSET: '+ ass);
System.debug('£ ASSETID: '+ ass.Id);
System.debug('£ ASSET COUNT: '+ AssList.get(0).Account.Device__c);
System.debug('£ ASSET PARENTID: '+ ass.ParentId);
System.debug('£ ASSETLIST: ' + AssList);
if(!AssList.isEmpty()) {
if(Ass.ParentId== null && Ass.Status =='Active') {
System.debug('£ ASSETLIST: ' + AssList);
Account a = new Account();
a.Id = AssOld.AccountId;
System.debug('£ ACCOUNTID: ' +a.Id);
Decimal devNumber = AssList.get(0).Account.Device__c;
if (devNumber>0) {
System.debug('£ NUMBER DEVICE BEFORE REMOVE: ' + devNumber);
a.Device__c =  devNumber - 1;   
accList.add(a);
System.debug('£ NUMBER DEVICE AFTER REMOVE: ' + a.Device__c);
}
}
}
}
}
}   

if(!accList.isEmpty()) {
update accList;
System.debug('£ LISTACCOUNT: '+ accList);
}
System.debug('£££ UPDATE ACCOUNTID END');
} */