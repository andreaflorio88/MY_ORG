public with sharing class CaseActivityListClass {

    /* Wrapper per il mascheramento di Event e Task in un super-oggetto Activity */
    public class Activity implements Comparable{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String ownerId;
        @AuraEnabled
        public String ownerName;
        @AuraEnabled
        public String contactName;
        @AuraEnabled
        public String contactId;
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String subject;
        @AuraEnabled
        public Date dueDate;
        @AuraEnabled
        public String dueDateString;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public Boolean isEvent;
        @AuraEnabled
        public Boolean isTask;

        public Integer compareTo(Object compareTo) {
            Activity activityCompared = (Activity)compareTo;

            if(this.dueDate == activityCompared.dueDate)
                return 0;
            if(this.dueDate > activityCompared.dueDate)
                return -1;
            else
                return 1;
        }
    }

    /*Mappa per la gestione della corrispondenza mese inglese/italiano*/
    public static Map<String, String> monthMap = new Map<String, String>{
        'Jan' => 'gen',
        'Feb' => 'feb',
        'Mar' => 'mar',
        'Apr' => 'apr',
        'May' => 'mag',
        'Jun' => 'giu',
        'Jul' => 'lug',
        'Aug' => 'ago',
        'Sep' => 'set',
        'Oct' => 'ott',
        'Nov' => 'nov',
        'Dec' => 'dec'
    };

    /* Metodo per il recupero e l'esposizione in lwc di una collection di Activity */
    @AuraEnabled(cacheable=true)
    public static List<Activity> getActivities(Id caseId, Integer max_result){

        List<Activity> result = new List<Activity>();
        List<Activity> result_temp = new List<Activity>();

        List<Task> task_list = [SELECT OwnerId, Owner.Name, Subject, WhoId, AccountId,
                                Who.Name, ActivityDate, Description
                                FROM Task
                                WHERE AccountId IN
                                (SELECT AccountId
                                FROM Case
                                WHERE Id =:caseId)
                                AND ActivityDate != null
                                ORDER BY ActivityDate DESC];

        List<Event> event_list = [SELECT OwnerId, Owner.Name, Subject, WhoId, AccountId,
                                Who.Name, ActivityDate, ActivityDateTime, Description
                                FROM Event
                                WHERE AccountId IN
                                (SELECT AccountId
                                FROM Case
                                WHERE Id =:caseId)
                                AND ActivityDate != null
                                ORDER BY ActivityDate DESC];

        /* Devo usare due cicli for e non un metodo unico perchè per gli sObject
        non sarebbe possibile recuperare i campi compositi es. Owner.Name con un get() */
        for(Task t : task_list){
            Activity a = new Activity();
            a.Id = t.Id;
            a.subject = t.Subject;
            a.contactId = t.WhoId;
            a.ownerId = t.OwnerId;
            a.accountId = t.AccountId;
            a.description = t.description;
            a.ownerName = t.Owner.Name;
            a.contactName = t.Who.Name;
            a.dueDate = t.ActivityDate;
            a.dueDateString = getDateString(DateTime.newInstance(t.ActivityDate, Time.newInstance(0, 0, 0, 0)).format('d-MMM-YY'));
            a.isTask = true;
            result_temp.add(a);
        }

        for(Event e : event_list){
            Activity a = new Activity();
            a.Id = e.Id;
            a.subject = e.Subject;
            a.contactId = e.WhoId;
            a.ownerId = e.OwnerId;
            a.accountId = e.AccountId;
            a.ownerName = e.Owner.Name;
            a.contactName = e.Who.Name;
            a.dueDate = e.ActivityDate;
            a.description = e.Description;
            a.dueDateString = getDateString(e.ActivityDateTime.format('d-MMM-YY'));
            a.isEvent = true;
            result_temp.add(a);
        }

        result_temp.sort();

        // Gestione del limite sulla collection risultante
        if(result_temp.size() > max_result){

            for(Integer i=0; i<max_result; i++)
                result.add(result_temp.get(i));
        }else{
            result = result_temp;
        }

        if(!result.isEmpty())
            return result;

        return null;
    }

    /*Metodo per la conversione del mese in italiano all'interno della data*/
    private static String getDateString(String sDate){

        if(system.UserInfo.getLanguage() == 'it'){
            String monthIT = monthMap.get(sDate.substringBetween('-'));
            if(monthIT != null)
                return sDate.replace(sDate.substringBetween('-'), monthIT);
            else
                return sDate;
        }
        else
            return sDate;
    }
}