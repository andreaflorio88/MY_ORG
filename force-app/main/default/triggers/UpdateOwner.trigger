trigger UpdateOwner on Preventivo__c (before update) {

for (Preventivo__c prev : trigger.new){

    if((Trigger.oldmap.get(prev.id).Stato__c=='Aperto')&&(Trigger.newmap.get(prev.Id).Presa_in_carico__c==True))
        
        {prev.ownerId = UserInfo.getUserID();
       
        }

}
}