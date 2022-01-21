trigger LendingCount on lending__c (after insert) {
    
    
    List<Lending__c> lendingListforUpdateLenCount = Trigger.New;
    if(!lendingListforUpdateLenCount.isEmpty()){
        Set<Id> accountIdSet = new Set<Id>();
        for (Lending__c acct: lendingListforUpdateLenCount){
            accountIdSet.add(acct.Trial_Periods__c);
        }
        if(!accountIdSet.isEmpty()){
            List<Account> accountToUpdate = [Select id, LendingCount__c, (Select id from Trial_Periods__r) from Account where id IN :accountIdSet];
            if(!accountToUpdate.isEmpty()){
                AssetTriggerHandler.bypass('testTriggerAsset');
                for(Account anAcc : accountToUpdate) {
                    anAcc.LendingCount__c = (anAcc.Trial_Periods__r != null ? anAcc.Trial_Periods__r.size() : 0);
                }
                update accountToUpdate;
            }
        }
    }
}