trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    List<BatchLeadConvertErrors__c> List_LeadConvertError = new List<BatchLeadConvertErrors__c>();
    
    for(BatchApexErrorEvent event: trigger.new){
    	BatchLeadConvertErrors__c lcerror = new BatchLeadConvertErrors__c();
        lcerror.AsyncApexJobId__c = event.AsyncApexJobId;
        lcerror.Records__c = event.JobScope;
        lcerror.StackTrace__c = event.StackTrace;
        
        List_LeadConvertError.add(lcerror);
    }
    if(List_LeadConvertError.size() > 0 && List_LeadConvertError != null){
    	insert List_LeadConvertError;
    }
}