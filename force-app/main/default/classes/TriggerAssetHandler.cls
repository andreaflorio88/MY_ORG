public without sharing class TriggerAssetHandler extends AssetTriggerHandler {
    
    public static final String ACTIVE = 'Active';
    public static final String RETURNED = 'Returned';
    public static final String UNLINKED = 'Unlinked'; 
    
    @TestVisible  
    protected override void afterInsert(){
        List<Asset> assetListforUpdateAccount = Trigger.New;
        if(!assetListforUpdateAccount.isEmpty()){
            System.debug('@@@ASSETLISTINSERT: ' + assetListforUpdateAccount);
            Map<Id,Id> mappAsset = new Map<Id,Id>();
            for (Asset accToId: assetListforUpdateAccount){
                //System.debug('@@@STATUS: '+ accToId.Status + ' @@@PARENTID: '+ accToId.ParentId);
                if(!(String.isBlank(accToId.Status)) && accToId.Status.equals(ACTIVE) && String.isBlank(accToId.ParentId) && !(String.isBlank(accToId.AccountId))){
                    mappAsset.put(accToId.Id, accToId.AccountId);
                    System.debug('@@@MAPPAASSET: '+ mappAsset);
                } 
            }
            Map<Id,Account> accountToUpdate = new Map<Id,Account>([Select id, Device__c from Account where id =: mappAsset.values()]);
            System.debug('@@@MAP: '+ accountToUpdate);
            if(!accountToUpdate.isEmpty()){
                for(Id idAccount : mappAsset.values()){
                    accountToUpdate.get(idAccount).Device__c = accountToUpdate.get(idAccount).Device__c  + 1;
                }
                update accountToUpdate.values();
            }
        }
    }
    
    protected override void afterUpdate(){
        Map<Id,Asset> assetNewMap = (Map<Id,Asset>)Trigger.NewMap;
        Map<Id,Asset> assetOldMap = (Map<Id,Asset>)Trigger.OldMap;
        Set<Id> accountIdSet = new Set<Id>(); 
        System.debug('@@@MAP: '+ assetNewMap );
        for(Id AssetId : assetNewMap.keySet()){
            if(!(assetNewMap.get(AssetId).Status).equals(assetOldMap.get(AssetId).Status)){ 
                if((assetOldMap.get(AssetId).Status).equals(UNLINKED) && (assetNewMap.get(AssetId).Status).equals(ACTIVE)){
                    accountIdSet.add(assetNewMap.get(AssetId).AccountId);
                    System.debug('@@@accountIdSet: '+ accountIdSet );
                }
                if((assetOldMap.get(AssetId).Status).equals(ACTIVE) && ((assetNewMap.get(AssetID).Status).equals(RETURNED) || (assetNewMap.get(AssetID).Status).equals(RETURNED))){
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
    }
       
    public static void accountToProcess(List<Account> accToProcess){
        for(Account anAcc : accToProcess) {
            anAcc.Device__c = (anAcc.Assets != null ? anAcc.Assets.size() : 0);
            System.debug('@@@anAcc.Device__c: '+ anAcc.Device__c );
        }
        update accToProcess;
    }
    
    
    @TestVisible
    //if(!(accOld.Status.equals(ACTIVE)) && ((accToId.Status.equals(ACTIVE))) && String.isBlank(accToId.ParentId) && !(String.isBlank(accToId.AccountId))){
    protected override void beforeInsert(){
        List<Asset> assetListforUpdateContact = Trigger.New;
        if(!assetListforUpdatecontact.isEmpty()){
            // SET ACCOUNT ID
            Set<Id> idAccount = new Set<Id>();
            for(Asset accToId: assetListforUpdateContact){
                if(String.isBlank(accToId.ParentId) && !(String.isBlank(accToId.AccountId))){
                    idAccount.add(accToId.AccountId);
                }
            }
            // SET K(ACCOUNTID) V(CONTACTID)
            Map<Id,Id> AccountIdTOPersonAccountIdMap = new Map<Id,Id>(); 
            for(Account mapAccount: [Select id from Account Where Id =: idAccount]){
                AccountIdTOPersonAccountIdMap.put(mapAccount.Id,mapAccount.Id);
            }
            if(!AccountIdTOPersonAccountIdMap.isEmpty()){
                for(Asset assetToUpdate: assetListforUpdateContact){
                    if(AccountIdTOPersonAccountIdMap.containskey(assetToUpdate.AccountId)){
                        assetToUpdate.ContactId = AccountIdTOPersonAccountIdMap.get(assetToUpdate.AccountId);
                        
                    }
                }
            }
        }
    }
}