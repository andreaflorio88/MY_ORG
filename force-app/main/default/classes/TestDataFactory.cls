@isTest
public class TestDataFactory {

    static User userCI;
    static User userMS;
    static User userCC;
    static User userCIeMS;

    public static Date datachiusura = Date.today();
    static String IBAN = 'IT60X0542811101000000123456';
    private static User userTecnico = [SELECT Id FROM User WHERE Name = 'User Salesforce' AND isActive = true LIMIT 1];


    /**
     * Metodo di supporto alla creazione di un utente con profilo Amministratore
     */
    public static User getAdminUser(Boolean putInDB){

        Profile profileAdmin = [SELECT Id FROM Profile WHERE Name = 'Amministratore' LIMIT 1];
        UserRole roleAdmin = [SELECT Id FROM UserRole WHERE Name = 'Cerved - Utenti Tecnici' LIMIT 1];

        User userAdmin = new User(Alias = 'usrAdmin', Email = 'usrAdmin@testorg.com', isActive = true,
                                  EmailEncodingKey = 'UTF-8', LastName = 'userAdmin', LanguageLocaleKey = 'en_US',
                                  LocaleSidKey = 'en_US', ProfileId = profileAdmin.Id, UserRoleId = roleAdmin.Id,
                                  TimeZoneSidKey = 'America/Los_Angeles', UserName = 'adm@provider.it', CG_Utente__c = 'CGTEST1');

        if(putInDB)
            insert userAdmin;

        return userAdmin;
    }

    /**
     * Metodo di supporto alla creazione di un utente con profilo Account e ruolo macro area 10
     */
    public static User getACC10User(Boolean putInDB){

        Profile profileACC10 = [SELECT Id FROM Profile WHERE Name = 'Key Account' LIMIT 1];
        UserRole roleACC10 = [SELECT Id FROM UserRole WHERE Name = 'Area - 10A2 - Grandi Utenti' LIMIT 1];

        User userACC10 = new User(Alias = 'usrac10', Email = 'userAC10@testorg.com', isActive = true,
                                  EmailEncodingKey = 'UTF-8', LastName = 'userAC10', LanguageLocaleKey = 'en_US',
                                  LocaleSidKey = 'en_US', ProfileId = profileACC10.Id, UserRoleId = roleACC10.Id,
                                  TimeZoneSidKey = 'America/Los_Angeles', UserName = 'a10@provider.it', CG_Utente__c = 'CGTEST1');

        if(putInDB)
            insert userACC10;

        return userACC10;
    }

    /**
    * Metodo di supporto per la creazione di un Account
    */
    public static Account getAccount(Boolean putInDB){

        Account acc = new Account(Name = 'ACME');

        if(putInDB)
            insert acc;

        return acc;
    }

    /**
    * Metodo di supporto per la creazione di un Contact
    */
    public static Contact getContact(Id accountId, Boolean putInDB){

        Contact con = new Contact(LastName = 'Fake Contact', AccountId = accountId);

        if(putInDB)
            insert con;

        return con;
    }

    /**
    * Metodo di supporto per la creazione di un' Opportunity
    */
    public static Opportunity getOpportunity(Id accountId, Boolean putInDB){

        Opportunity opp = new Opportunity(Name = 'Test', AccountId = accountId, stageName = 'Qualificata', CloseDate = System.today());

        if(putInDB)
            insert opp;

        return opp;
    }

    /**
    * Metodo di supporto per la creazione di una Quote
    */
    public static Quote getQuote(Id opportunityId, Boolean putInDB){

        Quote q = new Quote(Name = 'Test', OpportunityId = opportunityId);

        if(putInDB)
            insert q;

        return q;
    }

    /**
    * Metodo di supporto per la creazione di un Lead
    */
    public static Lead getLead(Boolean putInDB){

        Lead l = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company');

        if(putInDB)
            insert l;

        return l;
    }

    /**
    * Metodo di supporto per la creazione di una Campaign
    */
    public static Campaign getCampaign(Boolean putInDB){

        Campaign camp = new Campaign(Name = 'Test Campaign');

        if(putInDB)
            insert camp;

        return camp;
    }

    /**
    * Metodo di supporto per la creazione di un Contratto
    */
    public static Contract getContract(Id accountId, Boolean putInDB){

        Contract cont = new Contract(AccountId = accountId);

        if(putInDB)
            insert cont;

        return cont;
    }

    /**
    * Metodo di supporto per la creazione di un Ordine
    */
    public static Order getOrder(Id contractId, Boolean putInDB){

        Order ord = new Order();
        ord.ContractId = contractId;
        ord.EffectiveDate = System.now().Date();
        ord.Status = 'Attivo';

        if(putInDB)
            insert ord;

        return ord;
    }

    /**
    * Metodo di supporto per la creazione di un Pricebook
    */
    public static Pricebook2 getPricebook2(Boolean putInDB) {

        Pricebook2 pr = new Pricebook2(Name='Pricebook prova per calcolo provvigionale');

        if(putInDB)
            insert pr;

        return pr;
    }

    /**
    * Metodo di supporto per la creazione di una Soluzione Top Client
    */
    public static Soluzione_Top_Client__c getSoluzioneTopClient(Id opportunityId, Boolean putInDB){

        Soluzione_Top_Client__c sol = new Soluzione_Top_Client__c(Name = 'TEST', Opportunity__c = opportunityId, Totale_Consumi__c = 2000,
                                                                Tipo_Soluzione__c = 'Atoka Mobile', Tipo_Consumi__c = 'Una Tantum');

        if(putInDB)
            insert sol;

        return sol;
    }

    /**
    * Metodo di supporto per la creazione di un utente
    */
    public static User getUser(String profileId, String roleId, Boolean putInDB){

        User user = new User(	Alias = 'usr',
                                Email = 'user@testorg.com',
                                isActive = true,
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'user',
                                LanguageLocaleKey = 'it',
                                LocaleSidKey = 'it_IT',
                                ProfileId = profileId,
                                UserRoleId = roleId,
                                TimeZoneSidKey = 'America/Los_Angeles',
                                UserName = 'u@provider.it' + System.now().millisecond(),
                                ForecastEnabled = true);

        if(putInDB)
            insert user;

        return user;
    }

    /**
    * Metodo di supporto per la creazione di un Consumo Top Client
    */
    public static Consumo_Top_Client__c getConsumoTopClient(Id soluzioneId, Boolean putInDB){

        String currYear = String.valueOf(System.now().year());

        Consumo_Top_Client__c cons = new Consumo_Top_Client__c(Soluzione_Top_Client__c = soluzioneId, Chiave__c = soluzioneId + '_' + currYear, Anno__c = currYear);

        if(putInDB)
            insert cons;

        return cons;
    }

    /**
     * Metodo di supporto alla creazione di EmailMessages per Assistenza Clienti
     */
    public static Map<Id,EmailMessage> getACEmails(Id caseId){
        List<EmailMessage> emails = new List<EmailMessage>();

        EmailMessage e = new EmailMessage();
        e.ParentId = caseId;
        insert e;

        emails.add(e);
        return new Map<Id,EmailMessage>(emails);
    }

}