trigger AccountsTrigger on Account (after insert, after update, before insert, before update) {

    fflib_SObjectDomain.triggerHandler(Accounts.class);    
    
}