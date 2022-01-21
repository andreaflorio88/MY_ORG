@isTest
public class ForecastUsageTargetsClassTest {

    @TestSetup
    static void makeData(){

        Id rmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional Manager' LIMIT 1].Id;
        Id amProfileId = [SELECT Id FROM Profile WHERE Name = 'Area Manager' LIMIT 1].Id;
        Id keyAccountProfileId = [SELECT Id FROM Profile WHERE Name = 'Key Account' LIMIT 1].Id;
        UserRole userRole = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE Name = 'Area 10A1 - Grandi Utenti - Key Account' LIMIT 1];
        UserRole rmUserRole = [SELECT Id, Name, ParentRoleId FROM UserRole WHERE Name = 'Area 10A1 - Grandi Utenti' LIMIT 1];

        User keyAccountUser = TestDataFactory.getUser(keyAccountProfileId, userRole.Id, true);
        User amUser = TestDataFactory.getUser(amProfileId, userRole.ParentRoleId, true);
        User rmUser = TestDataFactory.getUser(rmProfileId, rmUserRole.ParentRoleId, true);

    }

    private static Riepilogo_Consumi_Top_Client__c getRiepilogoConsumi(String key, String userId, String anno, String mese){
        return new Riepilogo_Consumi_Top_Client__c( Anno__c = anno,
                                                    Mese__c = mese, 
                                                    Pipeline__c = 3, Canoni_e_Servizi__c = 3,
                                                    Canoni_e_Servizi_AP__c = 3, Normal_Usage__c = 3,
                                                    Quota__c = 3, Utente__c = userId, Chiave__c = key);
    }

    @isTest
    public static void getSubordinatesData_test(){

        User amUser = [SELECT UserRoleId FROM User WHERE Profile.Name = 'Area Manager' ORDER BY Createddate DESC LIMIT 1];
        List<User> subordinates_list = [SELECT Id FROM User WHERE UserRoleId IN (SELECT Id FROM UserRole WHERE ParentRoleId = :amUser.UserRoleId)];

        Test.startTest();

        List<ForecastUsageTargetsClass.UserData> result = new List<ForecastUsageTargetsClass.UserData>();

        System.runAs(amUser){
            result = ForecastUsageTargetsClass.getSubordinatesData(amUser.Id, '', 2020, 12);
        }

        Test.stopTest();
        //Test di recupero dei dati
        System.assertEquals(false, result.isEmpty());
    }

    @isTest
    public static void getSubordinatesDataAC_RM_test(){

        User rmUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Regional Manager' ORDER BY Createddate DESC LIMIT 1];
        User amUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Area Manager' ORDER BY Createddate DESC LIMIT 1];
        List<User> subordinates_list = [SELECT Id, CG_Utente__c FROM User WHERE UserRoleId IN (SELECT Id FROM UserRole WHERE ParentRoleId = :rmUser.UserRoleId)];

        List<Riepilogo_Consumi_Top_Client__c> riepilogoList = new List<Riepilogo_Consumi_Top_Client__c>();
        riepilogoList.add(getRiepilogoConsumi('test_1', amUser.Id, ''+System.today().year(), '2'));
        riepilogoList.add(getRiepilogoConsumi('test_2', rmUser.Id, ''+System.today().year(), '2'));
        
        insert riepilogoList;

        Test.startTest();

        List<ForecastUsageTargetsClass.UserData> result = new List<ForecastUsageTargetsClass.UserData>();
                                                            
        System.runAs(rmUser){
            result = ForecastUsageTargetsClass.getSubordinatesData(rmUser.Id, 'AC', System.today().year(), 12);
        }

        Test.stopTest();
        //Test di recupero dei dati
        System.assertEquals(false, result.isEmpty());
    }

    @isTest
    public static void getSubordinatesDataAC_AM_test(){

        User keyAccountUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Key Account' ORDER BY Createddate DESC LIMIT 1];
        User amUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Area Manager' ORDER BY Createddate DESC LIMIT 1];
        List<User> subordinates_list = [SELECT Id, CG_Utente__c FROM User WHERE UserRoleId IN (SELECT Id FROM UserRole WHERE ParentRoleId = :amUser.UserRoleId)];

        List<Riepilogo_Consumi_Top_Client__c> riepilogoList = new List<Riepilogo_Consumi_Top_Client__c>();
        riepilogoList.add(getRiepilogoConsumi('test_1', amUser.Id, ''+System.today().year(), '2'));
        riepilogoList.add(getRiepilogoConsumi('test_2', keyAccountUser.Id, ''+System.today().year(), '2'));
        
        insert riepilogoList;

        Test.startTest();

        List<ForecastUsageTargetsClass.UserData> result = new List<ForecastUsageTargetsClass.UserData>();
                                                            
        System.runAs(amUser){
            result = ForecastUsageTargetsClass.getSubordinatesData(amUser.Id, 'AC', 12, System.today().year());
        }

        Test.stopTest();
        //Test di recupero dei dati
        System.assertEquals(false, result.isEmpty());
    }

    @isTest
    public static void getSubordinatesData_KA_test(){

        User keyAccountUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Key Account' ORDER BY Createddate DESC LIMIT 1];

        Test.startTest();

        List<ForecastUsageTargetsClass.UserData> result = new List<ForecastUsageTargetsClass.UserData>();

        System.runAs(keyAccountUser){
            result = ForecastUsageTargetsClass.getSubordinatesData(keyAccountUser.Id, '', 2020, 12);
        }

        Test.stopTest();
        //Test di recupero dei dati
        System.assertEquals(false, result.isEmpty());
    }

    @isTest
    public static void getSubordinatesData1Q_test(){

        User rmUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Regional Manager' ORDER BY Createddate DESC LIMIT 1];
        User amUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Area Manager' ORDER BY Createddate DESC LIMIT 1];
        List<User> subordinates_list = [SELECT Id, CG_Utente__c FROM User WHERE UserRoleId IN (SELECT Id FROM UserRole WHERE ParentRoleId = :rmUser.UserRoleId)];

        Riepilogo_Consumi_Top_Client__c rc = getRiepilogoConsumi('test_1', amUser.Id, ''+System.today().year(), '2');
        insert rc;

        Test.startTest();

        List<ForecastUsageTargetsClass.UserData> result = new List<ForecastUsageTargetsClass.UserData>();
                                                            
        System.runAs(rmUser){
            result = ForecastUsageTargetsClass.getSubordinatesData(rmUser.Id, '1Q', System.today().year(), 2);
        }

        Test.stopTest();
        //Test di recupero dei dati
        System.assertEquals(false, result.isEmpty());
    }
	
    @isTest
    public static void upsertQuota_test(){
        
        List<User> user = [SELECT Id, CG_Utente__c FROM User LIMIT 1];
        Test.startTest();
		
        String key = '2020-12-' + user[0].CG_Utente__c;
		String json_insert = '[{"Id":"FQ-0","userId":"' + user[0].Id + '","quotaAmount":"100", "key":"' + key + '" }]';
        Boolean result = ForecastUsageTargetsClass.upsertData(json_insert, 12, 2020);
        
        Test.stopTest();
        //Test di recupero dell'operazione di insert e della quota
        List<Riepilogo_Consumi_Top_Client__c> rc = [SELECT Id, Quota__c FROM Riepilogo_Consumi_Top_Client__c WHERE Chiave__c =:key];
        System.assertEquals(100, rc[0].Quota__c);
        System.assertEquals(true, result);
    }
    
    @isTest
    public static void upsertQuotaError_test(){
        
        Test.startTest();
		
		String json_insert = '[{"Id":"FQ-0","userId":"test'  + '","quotaAmount":"100", "key":"' + 'test' + '" }]';
        Boolean result = ForecastUsageTargetsClass.upsertData(json_insert, 12, 2020);
        
        Test.stopTest();
        //Test di recupero dell'operazione di insert
        System.assertEquals(false, result);
    }

    @isTest
    public static void getOpportunity_test(){
        
        User keyAccountUser = [SELECT UserRoleId, CG_Utente__c FROM User WHERE Profile.Name = 'Key Account' ORDER BY Createddate DESC LIMIT 1];
        Account currAcc = TestDataFactory.getAccount(true);
        Opportunity opp = TestDataFactory.getOpportunity(currAcc.Id, false);
        opp.CloseDate = Date.newInstance(2020, 1, 1);
        opp.OwnerId = keyAccountUser.Id;
        //opp.RecordTypeId = getOpportunityRecordType('Top_Client');
        insert opp;
        Soluzione_Top_Client__c stp = TestDataFactory.getSoluzioneTopClient(opp.Id, true);

        Test.startTest();

            List<Opportunity> result = new List<Opportunity>();

            System.runAs(keyAccountUser){
                result = ForecastUsageTargetsClass.getOpportunities('1', '2020', keyAccountUser.Id);
            }

        Test.stopTest();
        //Test di recupero dei dati
        System.assertEquals(false, result.isEmpty());
    }
    
    // metodo per recuperare l'id del RecordType tramite il DeveloperName
    public static String getOpportunityRecordType(String developerName){

        return Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();
    
    }

}