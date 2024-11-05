@isTest
public class TestDataFactory {

    /**
    * Metodo di supporto per la creazione di un Account
    */
    public static Account getAccount(Boolean putInDB, String s, User u){

        Account acc = new Account(Name = 'ACME', Phone = '2132123');

        if(putInDB)
            insert acc;

        return acc;
    }
    
    public static Account getAccount(Boolean putInDB){

        Account acc = new Account(Name = 'ACME', Phone = '2132123');

        if(putInDB)
            insert acc;

        return acc;
    }


    /**
    * Metodo di supporto per la creazione di un Contact
    */
    public static Contact getContact(Id accountId, Boolean putInDB){

        Contact con = new Contact(LastName = 'Fake Contact', AccountId = accountId, Phone = '213515');

        if(putInDB)
            insert con;

        return con;
    }

    /**
    * Metodo di supporto per la creazione di un' Opportunity
    */
    public static Opportunity getOpportunity(Boolean putInDB, Account account, User u, String s){

        Opportunity opp = new Opportunity(Name = 'Test', AccountId = account.Id, stageName = 'Qualificata', CloseDate = System.today());

        if(putInDB)
            insert opp;

        return opp;
    }
    
    public static Opportunity getOpportunity(Id accountId, Boolean putInDB){

        Opportunity opp = new Opportunity(Name = 'Test', AccountId = accountId, stageName = 'Qualificata', CloseDate = System.today());

        if(putInDB)
            insert opp;

        return opp;
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
    * Metodo di supporto per la creazione di un Case
    */
    public static Case getCase(Boolean putInDB){

        Case c = new Case (OwnerId = UserInfo.getUserId(), Status = 'Aperto', Description = 'Test');

        if(putInDB)
            insert c;

        return c;
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
    * Metodo di supporto per la creazione di un CampaignMember
    */
    public static CampaignMember getCampaignMember(Id campaignId, Id contactId, Boolean putInDB){

        CampaignMember cm = new CampaignMember(CampaignId = campaignId, ContactId = contactId);

        if(putInDB)
            insert cm;

        return cm;
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
    * Metodo di supporto per la creazione di un utente
    */
    public static User getUser(Boolean putInDB, String profileId, String roleId){
		
        Id piD = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1]?.Id;
        Id riD = [SELECT Id FROM UserRole WHERE Name =:roleId LIMIT 1]?.Id;
        
        User user = new User(	Alias = 'usr',
                                Email = 'user@testorg.com',
                                isActive = true,
                                EmailEncodingKey = 'UTF-8',
                                LastName = 'user',
                                LanguageLocaleKey = 'it',
                                LocaleSidKey = 'it_IT',
                                ProfileId = piD,
                                UserRoleId = riD,
                                TimeZoneSidKey = 'America/Los_Angeles',
                                UserName = 'u@provider.it' + System.now().millisecond(),
                                ForecastEnabled = true);

        if(putInDB)
            insert user;

        return user;
    }
    
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

}