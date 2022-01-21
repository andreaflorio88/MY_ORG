public without sharing class CaseCustomerSatisfactionClass {

    //Fetch del valore di soddisfazione del case dal passare al F/E
    @AuraEnabled
    public static Decimal getCustomerSatisfaction(Id caseId){
        return [SELECT Soddisfazione_Cliente__c FROM Case WHERE Id =:caseId].Soddisfazione_Cliente__c;
    }

    //Set del valore di soddisfazione del cliente su Case e Account relativo
    @AuraEnabled
    public static void setCustomerSatisfaction(Id caseId, Decimal satisfaction){

        Case c = [SELECT contactId, accountId, Soddisfazione_Cliente__c FROM Case WHERE Id =:caseId FOR UPDATE];
        c.Soddisfazione_Cliente__c = satisfaction;
        update c;

        if(c.accountId != null){
            AggregateResult[] cases = [SELECT avg(Soddisfazione_Cliente__c) satisfaction FROM Case WHERE accountId =: c.accountId];
            Decimal avg_case = (Decimal)cases[0].get('satisfaction');

            Account acc = [SELECT Soddisfazione_Cliente__c FROM Account WHERE Id =: c.accountId FOR UPDATE];
            acc.Soddisfazione_Cliente__c = avg_case;
            update acc;
        }
    }

    //Sollecito della richiesta
    @AuraEnabled
    public static void sollecita(Id caseId){
        incrementSollecitoCount(caseId);
        sendSollecitoMail(caseId);
    }

    //Incremento del numero dei solleciti ricevuti
    @AuraEnabled
    public static void incrementSollecitoCount(Id caseId){

        Case c = [SELECT Sollecito__c FROM Case WHERE Id =:caseId];

        if(c.Sollecito__c == null || c.Sollecito__c == 0)
            c.Sollecito__c = 1;
        else
            c.Sollecito__c = c.Sollecito__c + 1;

        update c;
    }

    //Invio della mail di sollecito
    private static void sendSollecitoMail(Id caseId){

        EmailTemplate templateSollecito = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Notifica_Sollecito_Ticket'];
        Id ownerId = [SELECT ownerId FROM Case WHERE Id = :caseId].ownerId;
        Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'no-reply@cerved.com' LIMIT 1].Id;

        List<String> addresses = new List<String>();
        List<Messaging.SingleEmailMessage> mailsSollecito = new List<Messaging.SingleEmailMessage>();

        //Invio mail di sollecito all'utente owner
        if(String.valueOf(ownerId).startsWith('005')){

            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateSollecito.Id, ownerId, caseId);
            mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
            mail.setsaveAsActivity(false);
            mailsSollecito.add(mail);
            mail.setUseSignature(false);

        //Invio mail di sollecito a tutti gli utenti della coda owner
        }else if(String.valueOf(ownerId).startsWith('00G')){

            Id queueId = [SELECT Id FROM Group WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:ownerId) LIMIT 1].Id;
            for(User u : [SELECT Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:queueId)])
                addresses.add(u.email);

            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateSollecito.Id, UserInfo.getUserId(), caseId);
            mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
            mail.setToAddresses(addresses);
            mail.setsaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            mailsSollecito.add(mail);
            mail.setUseSignature(false);

            //Formattazione messaggio del commento
            String commentText = mail.getPlainTextBody();
            commentText = commentText.replace('Buongiorno,', '');
            if(commentText.contains('Per accedere'))
                commentText = commentText.replace(commentText.substring(commentText.indexOf('Per accedere'), commentText.length()), '');

            insert new CaseComment(CommentBody = commentText, parentId = caseId);
        }

        if(!mailsSollecito.isEmpty())
            Messaging.sendEmail(mailsSollecito, false);
    }
}