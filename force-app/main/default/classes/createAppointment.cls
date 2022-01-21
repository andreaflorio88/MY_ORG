public class createAppointment{

    public Lead contextLead {get;set;}
    public String contextStatus {get;set;}
    public String phone {get;set;}
    public String answer {get;set;}
    public List<selectOption> optionList {get;set;}
    
    public createAppointment(){
        String idLeadInput = apexpages.currentpage().getparameters().get('idLead');
        List<Lead> leadList = [SELECT id,IsConverted,FirstName,LastName,Email,Phone FROM Lead WHERE id =: idLeadInput ];
        
        optionList = new List<selectOption>();
        optionList.add(new selectOption('9.00 - 10.00' ,  '9.00 - 10.00'));
        optionList.add(new selectOption('10.00 - 11.00', '10.00 - 11.00'));
        optionList.add(new selectOption('11.00 - 12.00', '11.00 - 12.00'));
        optionList.add(new selectOption('12.00 - 13.00', '12.00 - 13.00'));
        optionList.add(new selectOption('14.00 - 15.00', '14.00 - 15.00'));
        optionList.add(new selectOption('15.00 - 16.00', '15.00 - 16.00'));
        optionList.add(new selectOption('16.00 - 17.00', '16.00 - 17.00'));
        optionList.add(new selectOption('17.00 - 18.00', '17.00 - 18.00'));
        
        if(leadList.size() > 0){
            contextLead = leadList.get(0); 
            contextStatus  = '1';
        }else{
            //messaggio d'errore
            contextStatus  = '10';
        }

    }

    
    public void doAction(){
        try{
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(contextLead.id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            if(!lcr.isSuccess())  
                contextStatus = '30';
                Task t = new Task();
                t.Priority = 'High';
                t.OwnerId = '005580000029lEBAAY';
                t.Status = 'In Progress';
                t.Subject = 'Call';
                t.WhoId = lcr.getContactId();
                t.fascia_oraria__c = answer;       
                insert t;
            	Contact con = new Contact();
            	con.Id = lcr.getContactId();
            	con.Phone = phone;
            	update con;
                contextStatus = '20';
        }catch(Exception ecc){
            contextStatus = '30';
        }
    }
}