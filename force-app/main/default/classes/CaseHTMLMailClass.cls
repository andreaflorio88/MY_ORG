public without sharing class CaseHTMLMailClass {

    @AuraEnabled
    public static String getHTMLMail(Id caseId){
        EmailMessage e = [SELECT HtmlBody, TextBody FROM EmailMessage WHERE parentId =:caseId ORDER BY Createddate ASC LIMIT 1];

        if(String.isNotBlank(e.HtmlBody))
            return e.HtmlBody;
        else
           return e.TextBody;
    }

	@AuraEnabled
    public static Case getCase(Id caseId){
        return [SELECT Subject, Origin, Description FROM Case WHERE Id =: caseId];
    }
}