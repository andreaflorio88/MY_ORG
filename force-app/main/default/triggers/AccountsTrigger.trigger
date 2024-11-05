trigger AccountTrigger on Account (after insert) {
    
    if(Trigger.isInsert)
        AccountTriggerHandler.handleAfterInsert(Trigger.new);
    
}
