public without sharing class CaseEditVisibilityClass {

    public class LockResult{
        @AuraEnabled
        public Boolean isAlreadyLocked;
        @AuraEnabled
        public String lockString;

        public LockResult(Boolean isAlreadyLocked, String lockString){
            this.isAlreadyLocked = isAlreadyLocked;
            this.lockString = lockString;
        }
    }

    //Metodo di controllo e set del campo isLockedBy del record
    @AuraEnabled
    public static LockResult checkAndSetLock(Id caseId){

        Map<Id,Profile> adminProfileMap = new Map<Id,Profile>([SELECT Id FROM Profile WHERE Name = 'Amministratore']);

        if(!adminProfileMap.containsKey(UserInfo.getProfileId()) || Test.isRunningTest()){

            Case c = [SELECT isLockedBy__c FROM Case WHERE Id =: caseId];

            if(String.isBlank(c.isLockedBy__c)){

                c.isLockedBy__c = UserInfo.getUserId() + '*' + UserInfo.getName() + '*' + System.now().format();
                update c;

                return new LockResult(false, null);
            }else if(c.isLockedBy__c.contains(UserInfo.getUserId()))
                return new LockResult(false, null);
            else
                return new LockResult(true, c.isLockedBy__c);
        }
        else
            return new LockResult(false, null);
    }

    //Metodo di unset del campo isLockedBy del record
    @AuraEnabled
    public static void unsetLock(Id caseId){
        Case c = [SELECT isLockedBy__c FROM Case WHERE Id =: caseId];

        if(!String.isBlank(c.isLockedBy__c) && c.isLockedBy__c.contains(UserInfo.getUserId())){

            c.isLockedBy__c = null;
            update c;
        }
    }
}