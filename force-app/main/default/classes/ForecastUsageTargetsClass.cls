public without sharing class ForecastUsageTargetsClass {

    private static String USER_ID;
    private static final String Q1 = '1Q';
    private static final String Q2 = '2Q';
    private static final String Q3 = '3Q';
    private static final String Q4 = '4Q';
    private static final Date TODAY = System.today();
    private static final Integer THIS_YEAR = System.Today().year();

    /* Wrapper per i dati visualizzati nel componente */
    public class UserData{
        @AuraEnabled
        public User u;
        @AuraEnabled
        public String key;
        @AuraEnabled
        public ForecastUsage f;
        @AuraEnabled
        public Boolean isHeaderRow;
        @AuraEnabled
        public Boolean isTeamTotalRow;
        @AuraEnabled
        public Boolean isTotalRow;
        @AuraEnabled
        public Boolean isPersonalRow;
        @AuraEnabled
        public Boolean isEditableRow;
        @AuraEnabled
        public Boolean hasViewRecord;

        UserData(User u, String key, ForecastUsage f){
            this.u = u;
            this.f = f;
            this.key = key;
            this.isHeaderRow = f.id == 'FU-0';
            this.isTotalRow = f.id == 'FU-9999';
            this.isTeamTotalRow = f.id == 'FU-9998';
            this.isPersonalRow = u.Id == UserInfo.getUserId();
            this.isEditableRow = !(this.isTotalRow || this.isPersonalRow);
            this.hasViewRecord = !this.isTeamTotalRow && !this.isTotalRow && !this.isPersonalRow && u.Id != USER_ID &&
                                (u.Profile.Name == 'Area Manager' || u.Profile.Name == 'Regional Manager');
        }
    }

    /* Wrapper per i forecast consumi */
    public class ForecastUsage{

        @AuraEnabled
        public String id;
        @AuraEnabled
        public String rtf;
        @AuraEnabled
        public String canonieServiziAP;
        @AuraEnabled
        public String canonieServizi;
        @AuraEnabled
        public String normalUsage;
        @AuraEnabled
        public String pipeline;
        @AuraEnabled
        public String quotaAmount;
        @AuraEnabled
        public String retQuotaUsage;
        @AuraEnabled
        public String forecast;
        @AuraEnabled
        public String lineare;

        ForecastUsage(Integer id, Decimal canonieServiziAP, Decimal canonieServizi, Decimal normalUsage, Decimal pipeline, Decimal quotaAmount, Decimal retQuotaUsage, Decimal forecast, Decimal lineare){
            this.id                 = 'FU-' + id;
            this.rtf                = 'RTF-' + Id;
            this.canonieServiziAP   = setDecimalPlaces(canonieServiziAP).format();
            this.canonieServizi     = setDecimalPlaces(canonieServizi).format();
            this.normalUsage        = setDecimalPlaces(normalUsage).format();
            this.pipeline           = setDecimalPlaces(pipeline).format();
            this.quotaAmount        = setDecimalPlaces(quotaAmount).format();
            this.retQuotaUsage      = setDecimalPlaces(retQuotaUsage).format();
            this.forecast           = setDecimalPlaces(forecast).format();
            this.lineare            = setDecimalPlaces(lineare).format();
        }
    }
    
    /* Wrapper per i riepiloghi */
    public class RiepilogoWrapper{

	@AuraEnabled
	public Decimal canonieServiziAP;
	@AuraEnabled
	public Decimal canonieServizi;
	@AuraEnabled
	public Decimal normalUsage;
	@AuraEnabled
	public Decimal pipeline;
	@AuraEnabled
	public Decimal quotaAmount;
	@AuraEnabled
	public Decimal retQuotaUsage;
	@AuraEnabled
	public Decimal forecast;
    @AuraEnabled
	public Decimal lineare;
		
		RiepilogoWrapper(){
			this.canonieServiziAP   = 0;
			this.canonieServizi     = 0;
			this.normalUsage        = 0;
			this.pipeline           = 0;
			this.quotaAmount        = 0;
			this.retQuotaUsage      = 0;
			this.forecast           = 0;
            this.lineare            = 0;
		}

	}
	
	/* Metodo utilizzato per settare i campi amount per il current user,  */
    public static RiepilogoWrapper setTotali(RiepilogoWrapper riepilogo, Decimal canonieServiziAP, Decimal canonieServizi, Decimal normalUsage,
                                             Decimal pipeline, Decimal retQuotaUsage, Decimal forecast, Decimal quotaAmount, Decimal lineare){
		riepilogo.canonieServiziAP 	+= setDecimalValueInNullCase(canonieServiziAP);
		riepilogo.canonieServizi 	+= setDecimalValueInNullCase(canonieServizi);
		riepilogo.normalUsage 		+= setDecimalValueInNullCase(normalUsage);
		riepilogo.pipeline 			+= setDecimalValueInNullCase(pipeline);
		riepilogo.retQuotaUsage 	+= setDecimalValueInNullCase(retQuotaUsage);
        riepilogo.forecast 			+= setDecimalValueInNullCase(forecast);
        riepilogo.quotaAmount       =  setDecimalValueInNullCase(quotaAmount);
        riepilogo.lineare           += setDecimalValueInNullCase(lineare);
		return riepilogo;
	}

    //Metodo utilizzato per verificare se il valore è di un parametro è null. In tal caso restituisce 0
    private static Decimal setDecimalValueInNullCase(Decimal value){
        return value != null ? value : 0;
    }

    /* Metodo utilizzato per settare i campi amount con 2 cifre decimali */
    private static Decimal setDecimalPlaces(Decimal amount){
        return amount != null ? amount.setScale(0) : 0;
    }

    /* Metodo per la costruizione della query sui quarter */
    public static Map<String,String> quarterMap = new Map<String,String>{
        Q1 => '\'1' +'\',' + '\'2' +'\',' + '\'3\'',
        Q2 => '\'4' +'\',' + '\'5' +'\',' + '\'6\'',
        Q3 => '\'7' +'\',' + '\'8' +'\',' + '\'9\'',
        Q4 => '\'10' +'\',' + '\'11' +'\',' + '\'12\''
    };

    /* Strutture dati */
    public static Set<String> userRoles_set;
    public static Map<String, List<String>> roleTree_map = new Map<String, List<String>>();

    //metodo utilizzato per recuperare i dati da visualizzare all'interno della component
    @AuraEnabled
    public static List<UserData> getSubordinatesData(String userId, String criterio, Integer year, Integer month){

        USER_ID = [SELECT Name FROM User WHERE Id = :userId].Name == 'Daniele Rodighiero' ? [SELECT Id FROM User WHERE Name = 'Sebastiano Culinas'].Id : userId;
        List<User> user_list = new List<User>();
        List<UserData> result = new List<UserData>();
        Map<Id,List<Riepilogo_Consumi_Top_Client__c>> userId_riepilogoConsumi_map = new Map<Id,List<Riepilogo_Consumi_Top_Client__c>>();

        User currentUser = [SELECT UserRoleId, ForecastEnabled, Name, SmallPhotoUrl, UserRole.Name, CG_Utente__c, Profile.Name
                            FROM User WHERE Id = :USER_ID LIMIT 1];

        //Lista degli utenti da cui recuperare il riepilogo dei consumi
        user_list = [SELECT Name, SmallPhotoUrl, UserRoleId, UserRole.Name, CG_Utente__c, Profile.Name
                        FROM User
                        WHERE UserRoleId IN
                        (SELECT Id
                        FROM UserRole
                        WHERE ParentRoleId = :currentUser.UserRoleId) AND IsActive = true
                        ORDER BY FirstName ASC];
        user_list.add(currentUser);
        System.debug('@@@user_list: '+ user_list);
        
        //String query e condizione
        String condizione = setCondizioneCriterio(criterio, month, year);
        String query = buildQuery(user_list, condizione);
        System.debug('@@@condizione: '+ condizione);
        System.debug('@@@query: '+ query);

        //Mappa con il riepilogo dei Consumi per ciascun utente per periodo selezionato
        for(Riepilogo_Consumi_Top_Client__c rc : Database.query(query))
            if(userId_riepilogoConsumi_map.containsKey(rc.Utente__c))
                userId_riepilogoConsumi_map.get(rc.Utente__c).add(rc);
            else
                userId_riepilogoConsumi_map.put(rc.Utente__c, new List<Riepilogo_Consumi_Top_Client__c>{rc});
		System.debug('@@@userId_riepilogoConsumi_map: '+ userId_riepilogoConsumi_map);
        
        //Variabili per i valori totali
        Integer count = 0;
        RiepilogoWrapper currUser = new RiepilogoWrapper();
        RiepilogoWrapper totaleTeam = new RiepilogoWrapper();
    
        //Init della mappa dei ruoli
        initRoleTree_map();
    
        for(User u : user_list){    
    
            Boolean isCurrentUser = u.Id == USER_ID;
            String key = year + '-' + month + '-' + u.CG_Utente__c;
            RiepilogoWrapper noCurrUser = new RiepilogoWrapper();
            Decimal quota  = 0;

            /*  Regole di visualizzazione dei dati
                Agente:
                    visualizzerà i suoi soli record di consumi
                Area Manager:
                    visualizzerà i consumi degli agenti ed i suoi
                    TotaleTeam sarà la somma dei dati del team
                    Totale sarà la somma del TotaleTeam e dei suoi dati
                Regional Manager:
                    visualizzerà i consumi degli Area Manager (Totale di sopra) ed i suoi
                    TotaleTeam sarà la somma dei dati degli area manager
                    Totale sarà la somma del TotaleTeam e dei suoi dati
            */

            /*****************  AGENTE ******************/
            if(currentUser.Profile.Name == 'Key Account'){
                setSumUser(userId_riepilogoConsumi_map, u, currUser, totaleTeam, quota, criterio, true);
                result.add(new UserData(u, key, new ForecastUsage(count, currUser.canonieServiziAP, currUser.canonieServizi, currUser.normalUsage, currUser.pipeline, currUser.quotaAmount, currUser.retQuotaUsage, currUser.forecast, currUser.lineare)));
            }
            /*****************  AGENTE ******************/

            /*****************  AREA MANAGER ******************/
            if(currentUser.Profile.Name == 'Area Manager'){
                // Agente
                if(!isCurrentUser){
                    setSumUser(userId_riepilogoConsumi_map, u, noCurrUser, totaleTeam, quota, criterio, true);
                    result.add(new UserData(u, key, new ForecastUsage(count, noCurrUser.canonieServiziAP, noCurrUser.canonieServizi, noCurrUser.normalUsage, noCurrUser.pipeline, noCurrUser.quotaAmount, noCurrUser.retQuotaUsage, noCurrUser.forecast, noCurrUser.lineare)));
                }
                // Area Manager
                else {
                    setSumUser(userId_riepilogoConsumi_map, u, currUser, totaleTeam, quota, criterio, false);
                    result.add(new UserData(u, key, new ForecastUsage(count, currUser.canonieServiziAP, currUser.canonieServizi, currUser.normalUsage, currUser.pipeline, currUser.quotaAmount, currUser.retQuotaUsage, currUser.forecast, currUser.lineare)));
                }
                count ++;
            }
            /*****************  AREA MANAGER ******************/

            /*****************  REGIONAL MANAGER / DIREZIONE ******************/
            if(currentUser.Profile.Name == 'Regional Manager' || currentUser.Profile.Name == 'Direzione'){
                // Area Manager - Regional Manager
                if(!isCurrentUser){

                    if(userId_riepilogoConsumi_map.containsKey(u.Id))
                        quota = userId_riepilogoConsumi_map.get(u.Id)[0].Quota__c;
                    
                    AggregateResult agr = getRiepilogoConsumiforRole(roleTree_map, count, result, u, condizione, key, u.Id, 'area manager');
                    AggregateResult nu;

                    if(criterio == 'AC')
                        nu = getRiepilogoConsumiforRole(roleTree_map, count, result, u, condizione, key, u.Id, criterio);

                    if(agr != null){

                        Decimal normalUsage = criterio == 'AC' ? (nu != null ? getAmount(nu,'normalUsage') : 0) : getAmount(agr,'normalUsage');

                        noCurrUser = setTotali(noCurrUser, getAmount(agr,'canonieServiziAP'), getAmount(agr,'canonieServizi'), normalUsage, getAmount(agr,'pipeline'), getAmount(agr,'retNormalUsage'), getAmount(agr,'forecast'), quota, getAmount(agr,'lineare'));
                        
                        totaleTeam = setTotali(totaleTeam, noCurrUser.canonieServiziAP, noCurrUser.canonieServizi, noCurrUser.normalUsage, noCurrUser.pipeline, noCurrUser.retQuotaUsage, noCurrUser.forecast, noCurrUser.quotaAmount, noCurrUser.lineare);
                    }
                    result.add(new UserData(u, key, new ForecastUsage(count, noCurrUser.canonieServiziAP, noCurrUser.canonieServizi, noCurrUser.normalUsage, noCurrUser.pipeline, noCurrUser.quotaAmount, noCurrUser.retQuotaUsage, noCurrUser.forecast, noCurrUser.lineare)));
                }
                // Regional Manager - Direzione
                else {
                    setSumUser(userId_riepilogoConsumi_map, u, currUser, totaleTeam, quota, criterio, false);
                    result.add(new UserData(u, key, new ForecastUsage(count, currUser.canonieServiziAP, currUser.canonieServizi, currUser.normalUsage, currUser.pipeline, currUser.pipeline, currUser.retQuotaUsage, currUser.forecast, currUser.lineare)));
                }
                count ++;
            }
            /*****************  REGIONAL MANAGER ******************/
        }
		System.debug('@@@user_list.size(): ' + user_list.size());
        System.debug('@@@user_list: ' + user_list);
        if(user_list.size() > 1){
            
            User totale = new User(LastName = 'Totale', Id = currentUser.Id);        
            result.add(new UserData(totale, '', new ForecastUsage(9998, totaleTeam.canonieServiziAP, totaleTeam.canonieServizi, totaleTeam.normalUsage, totaleTeam.pipeline, null, totaleTeam.retQuotaUsage, totaleTeam.forecast, totaleTeam.lineare))); // totale team
            result.add(new UserData(totale, '', new ForecastUsage(9999, currUser.canonieServiziAP+totaleTeam.canonieServiziAP, currUser.canonieServizi+totaleTeam.canonieServizi, currUser.normalUsage+totaleTeam.normalUsage, 
                                                                        currUser.pipeline+totaleTeam.pipeline, null, currUser.retQuotaUsage+totaleTeam.retQuotaUsage, currUser.forecast+ totaleTeam.forecast, currUser.lineare+ totaleTeam.lineare))); // totale
        }
        
        System.debug('@@@result: '+ result);
        return result;
    }

    //metodo utilizzato per l'upsert dei riepiloghi
    @AuraEnabled
    public static Boolean upsertData(String quotasToUpsert_json, Integer month, Integer year){
        Boolean result = false;
        List<Riepilogo_Consumi_Top_Client__c> quotasToUpsert = new List<Riepilogo_Consumi_Top_Client__c>();

        try {
            for(Object obj : (List<Object>)JSON.deserializeUntyped(quotasToUpsert_json)){
                Map<String, Object> m = (Map<String, Object>)obj;
                String key = (String) m.get('key');

                System.debug('@@@m:' + m);
                if(m.containsKey('key'))
                    quotasToUpsert.add(getRiepilogo(key, (String) m.get('userId'), (String) m.get('rtf'), (String) m.get('quotaAmount')));
                 else
                    quotasToUpsert.add(getRiepilogo(key, (String) m.get('userId'), (String) m.get('rtf'), (String) m.get('quotaAmount')));
                }

            Database.upsert(quotasToUpsert, Riepilogo_Consumi_Top_Client__c.fields.Chiave__c, false);
            result = true;

        } catch (Exception e) {
            System.debug(e.getMessage());
            return result;
        }

        return result;
    }

    //metodo utilizzato per settare il record di riepilogo
    public static Riepilogo_Consumi_Top_Client__c getRiepilogo(String key, String userId, String rtf, String quota){
        Riepilogo_Consumi_Top_Client__c rc = new Riepilogo_Consumi_Top_Client__c();
        rc.Chiave__c = key;
        rc.Anno__c = key.split('-')[0];
        rc.Mese__c = key.split('-')[1];
        rc.Utente__c = userId;
        if(String.isNotBlank(rtf))     rc.Rettifica_Normal_Usage__c = Decimal.valueOf(rtf);
        if(String.isNotBlank(quota))   rc.Quota__c = Decimal.valueOf(quota);

        return rc;
    }

    //metodo utilizzato per settare i valori dei riepiloghi degli area manager quando la maschera viene aperta dal regional manager
    public static AggregateResult getRiepilogoConsumiforRole(Map<String, List<String>> roleTree_map, Integer counter, List<UserData> result, 
                                                            User u, String condizione, String key, Id currenteUserId, String criterio){

        AggregateResult agr;
        String query;
        userRoles_set = new Set<String>();
        getRecursiveRoles(roleTree_map, u.UserRoleId);
        userRoles_set.remove(u.UserRoleId); 

        //se il criterio è AC prenderò i soli valori aggregati di normalUsage per i mesi restanti dell'anno
        if(criterio == 'AC'){
            Set<String> monthSet = new Set<String>();
            for(Integer i = TODAY.month(); i<=12; i++)
                monthSet.add(''+i);

            query = 'SELECT SUM(Normal_Usage__c) normalUsage FROM Riepilogo_Consumi_Top_Client__c ' +
                        'WHERE Mese__c IN :monthSet AND Anno__c =\'' + THIS_YEAR +'\'' + ' AND Utente__r.IsActive = true ' +
                        'AND (Utente__r.UserRoleId IN :userRoles_set OR Utente__c =\'' + currenteUserId + '\')';
        }
        else {
            query = 'SELECT SUM(Normal_Usage__c) normalUsage, SUM(Pipeline__c) pipeline, SUM(Canoni_e_Servizi__c) canonieServizi, ' +
                        'SUM(Canoni_e_Servizi_AP__c) canonieServiziAP, SUM(Lineare__c) lineare,' +
                        'SUM(Forecast__c) forecast, SUM(Rettifica_Normal_Usage__c) retNormalUsage ' +
                        'FROM Riepilogo_Consumi_Top_Client__c ' + 
                        'WHERE '+ condizione + ' AND Utente__r.IsActive = true ' +
                        'AND (Utente__r.UserRoleId IN :userRoles_set OR Utente__c =\'' + currenteUserId + '\')';
        }

        List<AggregateResult> queryResult = Database.query(query);
        agr = queryResult.get(0);

        return agr;
    }

    //metodo utilizzato per settare i valori restituiti dalla query
    private static Decimal getAmount(AggregateResult agr, String name){
        return (agr.get(name) == null ? 0 : (Decimal) agr.get(name));
    }

    //metodo utilizzato per creare la query a seconda del criterio selezionato
    public static String buildQuery(List<User> user_list, String condizione){
                
        return 'SELECT Chiave__c, Mese__c, Anno__c, Utente__c, Pipeline__c, Quota__c, Forecast__c, Lineare__c, ' + 
                'Canoni_e_Servizi__c, Canoni_e_Servizi_AP__c, Normal_Usage__c, Rettifica_Normal_Usage__c ' +
                'FROM Riepilogo_Consumi_Top_Client__c ' +
                'WHERE Utente__c IN :user_list' + 
                ' AND ' + condizione;
    }

    //metodo utilizzato per settare le condizioni della query a seconda del criterio
    public static String setCondizioneCriterio(String criterio, Integer month, Integer year){
        String condizione = '';
        String setYearCondition = '';
        Date today = System.today();
        Integer thisYear = System.today().year();
        
        if(criterio == 'AC'){
            condizione = 'Anno__c =\'' + thisYear +'\'';
        }
        else if(criterio == 'PA'){
            condizione = 'Anno__c =\'' + (thisYear + 1) +'\'';
        }
        else if(criterio.contains(Q1) || criterio.contains(Q2) || criterio.contains(Q3) || criterio.contains(Q4)){
            condizione = setQueryConditions(criterio);
        }
        else {
            condizione = 'Anno__c =\'' + year +'\'' + ' AND Mese__c =\'' + month + '\'';
        }
        
        return condizione;
    }

    // metodo utilizzato settare la query dinamicamente in caso di quarter
    public static String setQueryConditions(String criterio){
        String month = '';
        List<String> criterioSet = criterio.split(','); 
        
        for(String str: criterioSet){
            if(str.contains(Q1))
                month = String.isBlank(month) ? quarterMap.get(Q1) : month + ',' + quarterMap.get(Q1);
            else if(str.contains(Q2))
                month = String.isBlank(month) ? quarterMap.get(Q2) : month + ',' + quarterMap.get(Q2);
            else if(str.contains(Q3))
                month = String.isBlank(month) ? quarterMap.get(Q3) : month + ',' + quarterMap.get(Q3);
            else if(str.contains(Q4))
                month = String.isBlank(month) ? quarterMap.get(Q4) : month + ',' + quarterMap.get(Q4);
        }
        
        String condizione = '';
        condizione = 'Anno__c =\''  + THIS_YEAR + '\'' + ' AND Mese__c IN (' + month + ')';
        return condizione;   
    }

    public static void initRoleTree_map(){

        for(UserRole ur : [SELECT ParentRoleId, Name FROM UserRole]){

            if(!roleTree_map.containsKey(ur.ParentRoleId))
                roleTree_map.put(ur.ParentRoleId, new List<String>{ur.Id});
            else
                roleTree_map.get(ur.ParentRoleId).add(ur.Id);
        }
    }

    public static void getRecursiveRoles(Map<String, List<String>> parentRoles_roles_map, String parentRole){

        System.debug('$$$ parentRole' + parentRole);

        if(!parentRoles_roles_map.containsKey(parentRole))
            userRoles_set.add(parentRole);
        else{
            userRoles_set.add(parentRole);
            for(String role : parentRoles_roles_map.get(parentRole)){
                userRoles_set.add(role);
                getRecursiveRoles(parentRoles_roles_map, role);
            }
        }
    }

    //metodo utilizzato per recuperare i consumi per il mese, sull'utente selezionato
    @AuraEnabled
    public static List<Opportunity> getOpportunities(String mese, String anno, String userId){
	
        List<Opportunity> opportunities = new List<Opportunity>();
        Set<Id> oppIdSet = new Set<Id>();
        String topClientRt = getOpportunityRecordType('Top_Client');

        String query =  'SELECT Id, Soluzione_Top_Client__r.Opportunity__c ' +
                        'FROM Consumo_Top_Client__c ' +
                        'WHERE Anno__c =\'' + anno + '\'' + 'AND Mese_' + mese + '__c > 0 AND Soluzione_Top_Client__r.Opportunity__r.OwnerId =\'' + userId + '\' ' +
                        'AND Soluzione_Top_Client__r.Opportunity__r.RecordTypeId =\'' + topClientRt + '\'';
    
        for(Consumo_Top_Client__c ctp: Database.query(query)){
            oppIdSet.add(ctp.Soluzione_Top_Client__r.Opportunity__c);
        }
    
        opportunities = [SELECT Account.Name, Natura__c, Totale_Importo_Consumi__c, Probability, Priorita_Automatica__c, CloseDate, Owner.Name, StageName, Motivazione_Downgrade__c
                            FROM Opportunity
                            WHERE Id IN : oppIdSet];
        
        return opportunities;
    
    }
    
    @AuraEnabled
    public static String getOpportunityRecordType(String developerName){

        return Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();
    
    }

    @AuraEnabled
    public static String updateOpportunities(Object data) {
        try {
        List<Opportunity> opportunitiesForUpdate = (List<Opportunity>) JSON.deserialize(
            JSON.serialize(data),
            List<Opportunity>.class
        );
            update opportunitiesForUpdate;
            return 'Success';
        }
        catch (Exception e) {
            return e.getMessage();
        }
    }

    /*metodo utilizzato per settare il valore di normal usage
        - in caso di Anno corrente si prendono i valori dal mese corrente fino a fine anno
    */
    public static Decimal setNormalUsageValue(String criterio, Riepilogo_Consumi_Top_Client__c rc){
        Decimal normalUsage = 0;
        if(criterio == 'AC'){
            if(TODAY.monthsBetween(Date.newInstance(Integer.valueOf(rc.Anno__c), Integer.valueOf(rc.Mese__c), 1)) >= 0)
                normalUsage = rc.Normal_Usage__c;
        } else 
            normalUsage = rc.Normal_Usage__c;

        return normalUsage;
    } 

    //metodo utilizzato per settare i valori di RiepilogoWrapper 
    public static void setSumUser(Map<Id,List<Riepilogo_Consumi_Top_Client__c>> userId_riepilogoConsumi_map, User u, 
                                    RiepilogoWrapper currUser, RiepilogoWrapper totaleTeam, Decimal quota, String criterio, Boolean isTotalToset){
        if(userId_riepilogoConsumi_map.containsKey(u.Id)){
            quota = userId_riepilogoConsumi_map.get(u.Id)[0].Quota__c;
    
            for(Riepilogo_Consumi_Top_Client__c rc : userId_riepilogoConsumi_map.get(u.Id)){
    
                currUser = setTotali(currUser, rc.Canoni_e_Servizi_AP__c, rc.Canoni_e_Servizi__c, setNormalUsageValue(criterio, rc), rc.Pipeline__c, rc.Rettifica_Normal_Usage__c, rc.Forecast__c, quota, rc.Lineare__c);
                
                if(isTotalToset)
                    totaleTeam = setTotali(totaleTeam, rc.Canoni_e_Servizi_AP__c, rc.Canoni_e_Servizi__c, setNormalUsageValue(criterio, rc), rc.Pipeline__c, rc.Rettifica_Normal_Usage__c, rc.Forecast__c, quota, rc.Lineare__c);
            }
        }
    }

}