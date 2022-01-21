public without sharing class CaseOwnerClass {

    class OwnerException extends Exception{}

    public class CaseOwnerMessage{
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String message;

        public CaseOwnerMessage(String status, String message){
            this.status = status;
            this.message = message;
        }
    }

    //Fetch del nome dell' Owner corrente del Case
    @AuraEnabled
    public static String getOwnerName(Id caseId){
        return [SELECT Owner.Name FROM Case WHERE Id =:caseId].Owner.Name;
    }

    //Fetch di tutti i possibili Owner del Case
    @AuraEnabled(cacheable=true)
    public static List<OwnerWrapper> getPossibleOwners(Id caseId){
        List<OwnerWrapper> result = new List<OwnerWrapper>();
        List<String> queueNames = new List<String>();
		
        for(User u : [SELECT Name FROM User WHERE IsActive = true])
            result.add(new OwnerWrapper(u.Name, u.Id, false));        
        
        /*Utenti di Business
        Case currCase = [SELECT Id, RecordType.DeveloperName FROM Case WHERE Id =:caseId];
        if(currCase != null && currCase.RecordType.DeveloperName == 'Back_Office'){
        
        for(User u : [SELECT Name FROM User WHERE Profile.Name Like '%Business%'])
            result.add(new OwnerWrapper(u.Name, u.Id, false));
        
        return result;
        }

        //Utenti di Assistenza Clienti  
        for(User u : [SELECT Name FROM User WHERE Profile.Name Like '%Assistenza Clienti%'])
            result.add(new OwnerWrapper(u.Name, u.Id, false));

        //Code JIRA di 2° livello
        for(Assistenza_Clienti_Code__mdt coda : [SELECT Label FROM Assistenza_Clienti_Code__mdt])
            queueNames.add(coda.Label);

        //Code di 1° livello / 2° livello SF
        for(Group g : [SELECT Name FROM Group WHERE Type = 'Queue' AND Name IN :queueNames])
            result.add(new OwnerWrapper(g.Name, g.Id, true));*/

        return result;
    }

    //Auto assegnazione del case
    @AuraEnabled
    public static String selfAssign(Id caseId){
        Case c = [SELECT OwnerId FROM Case WHERE Id =:caseId];
        c.OwnerId = UserInfo.getUserId();

        update c;

        return UserInfo.getName();
    }
    
        /* Set dell' Owner del Case; se owner JIRA
     * devono essere compilati i campi obbligatori per la chiamata a WoRC
     * prima di poter fare la chiamata; se owner non JIRA viene fatto il set */
    @AuraEnabled
    public static CaseOwnerMessage setOwner(Id caseId, Id ownerId){

        try{
            
            setCaseOwner(caseId, ownerId);
            return new CaseOwnerMessage('OK', 'Il titolare è stato cambiato correttamente');
            
        }catch(Exception e){
            
            if(e instanceOf OwnerException)
                return new CaseOwnerMessage('KO', e.getMessage());
            else
                return new CaseOwnerMessage('KO', 'Si è verificato un problema durante il salvataggio dei dati. Se il problema persiste, contattare un amministratore');
        }
    }
    
    //Set dell'owner del case
    private static void setCaseOwner(Id caseId, Id ownerId){

        Case c = [SELECT OwnerId, Owner.Name, isLockedBy__c FROM Case WHERE Id =:caseId];

        if(!String.isBlank(c.isLockedBy__c) && !c.isLockedBy__c.contains(UserInfo.getUserId()))
            throw new OwnerException('La richiesta non può essere modificata perché aperta da un altro operatore');

        /*List<Group> ownerQueues = [SELECT Name FROM Group WHERE Type = 'Queue' AND Id =: ownerId];
        Boolean isPayline = !ownerQueues.isEmpty() && ownerQueues.get(0).Name == 'PAYLINE';
        Boolean isFinLine = !ownerQueues.isEmpty() && ownerQueues.get(0).Name == 'Supporto FinLine';

        if(isPayline){

            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Assegnazione_Payline'];
            String EmailPayline = [SELECT Email_Payline__c FROM Assistenza_Clienti__mdt WHERE DeveloperName = 'Default'].Email_Payline__c;

            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(template.Id, c.ownerId, c.Id);
            mail.setPlainTextBody(mail.getPlainTextBody() + ' ' + c.Thread_Mail_Assistenza__c);
            mail.setOrgWideEmailAddressId([SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Assistenza Clienti Salesforce Payline' LIMIT 1].Id);
            mail.setToAddresses(new List<String>{EmailPayline});
            mail.setsaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail}, false);
        }

        if(ownerId != UserInfo.getUserId() && ('' + ownerId).startsWith('005')){

            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Cambio_Titolare_Assistenza'];

            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(template.Id, ownerId, c.Id);
            mail.setsaveAsActivity(false);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail}, false);
        }*/

        c.OwnerId = ownerId;
        update c;

        //Se il caso va a Payline o a FinLine, deve essere tracciato ma tornare immediatamente all'utente corrente
        /*in modo tale che ogni mail successiva sia tracciata
        if(isPayline || isFinLine){
            c.OwnerId = UserInfo.getUserId();
        	update c;
        }*/
    }

}