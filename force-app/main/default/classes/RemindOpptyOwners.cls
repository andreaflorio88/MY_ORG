global class RemindOpptyOwners implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Opportunity> opptys = [SELECT Id, Name, OwnerId, CloseDate
            FROM Opportunity
            WHERE IsClosed = False AND
            CloseDate < TODAY];
        // Create a task for each opportunity in the list
        //TaskUtils.remindOwners(opptys);
    }
}