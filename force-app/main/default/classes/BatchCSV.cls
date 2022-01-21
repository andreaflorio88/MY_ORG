global class BatchCSV implements Schedulable{
   global void execute(SchedulableContext sc) {
    
    // list Inactive Account
    List<Account > acclist = [Select id, Name, Email__c, Phone from Account];
    string header = 'Account Id, Name, Birthdate, Email, Phone \n';
    System.debug(+acclist);
    string finalstr = header;
    for(Account a: acclist)
    {

           string recordString = a.id +','+ a.Name +','+ a.Email__c +','+ a.Phone+'\n';

           finalstr = finalstr + recordString;

    }
     
    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
    
    blob csvBlob = Blob.valueOf(finalstr);
    // parameter csv
    string csvname= 'Account.csv';
    csvAttc.setFileName(csvname);
    csvAttc.setBody(csvBlob);
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    // parameter mail
    String[] toAddresses = new list<string> {'andrea.florio@accenture.com'};
    String subject ='Inactive Account CSV';
    email.setSubject(subject);
    email.setToAddresses( toAddresses );
    email.setPlainTextBody('Inactive Account CSV');
    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});       
   }
}