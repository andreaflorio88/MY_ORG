public with sharing class OpportunitySoluzioniTopClient {

    @AuraEnabled
    public static List<Soluzione_Top_Client__c> getSoluzioni(Id opportunityId){
        return [SELECT Id, Name, Tipo_Soluzione__c FROM Soluzione_Top_Client__c WHERE Opportunity__c = :opportunityId ORDER BY Createddate ASC];
    }

    @AuraEnabled
    public static void deleteSoluzione(Id soluzioneId){
        delete [SELECT Id FROM Soluzione_Top_Client__c WHERE Id = :soluzioneId];
    }

    @AuraEnabled
    public static List<Consumo_Top_Client__c> getConsumi(Id opportunityId, String year){
        List<Consumo_Top_Client__c> consumiToReturn = new List<Consumo_Top_Client__c>();

        for(Consumo_Top_Client__c ctp: [SELECT Chiave__c, Soluzione_Top_Client__c, Soluzione_Top_Client__r.Tipo_Soluzione__c, Mese_1__c, Mese_2__c, Mese_3__c, Mese_4__c,
                            Mese_5__c, Mese_6__c, Mese_7__c, Mese_8__c, Mese_9__c, Mese_10__c, Mese_11__c, Mese_12__c
                            FROM Consumo_Top_Client__c
                            WHERE Anno__c = :year
                            AND Soluzione_Top_Client__c IN
                            (SELECT Id FROM Soluzione_Top_Client__c WHERE Opportunity__c = :opportunityId)]){
            
            Consumo_Top_Client__c consumo = ctp;
            for(Integer i=1; i<13; i++){
                consumo.put('Mese_'+i+'__c', ((Decimal) ctp.get('Mese_'+i+'__c')).setScale(2)); 
            }
            consumiToReturn.add(consumo);
        }
        
        return consumiToReturn;
    }

    @AuraEnabled
    public static String upsertConsumi(String jsonConsumi, String year){

        try{

            Map<String, Consumo_Top_Client__c> chiave_consumo_map = new Map<String, Consumo_Top_Client__c>();

            JSONParser parser = JSON.createParser(jsonConsumi);

            Consumo_Top_Client__c c;
            String mese;
            Decimal valore;

            while (parser.nextToken() != null) {

                if(parser.getCurrentToken() == JSONToken.START_OBJECT){

                    c = new Consumo_Top_Client__c();
                    mese = '';
                    valore = 0;
                }

                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText().startsWith('Mese')) {

                    mese = parser.getText();
                    parser.nextToken();
                    valore = String.isBlank(parser.getText()) ? 0 : Decimal.valueOf(parser.getText());
                }

                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'id'){

                    parser.nextToken();
                    c.Chiave__c = parser.getText();
                    c.Soluzione_Top_Client__c = parser.getText().split('_')[0];
                    c.Anno__c = parser.getText().split('_')[1];

                    if(chiave_consumo_map.containsKey(c.Chiave__c)){
                            c = chiave_consumo_map.get(c.Chiave__c);
                            c.put(mese, valore);
                        }
                    else
                        c.put(mese, valore);
                }

                if(parser.getCurrentToken() == JSONToken.END_OBJECT){
                    chiave_consumo_map.put(c.Chiave__c, c);
                }
            }

            Database.upsert(chiave_consumo_map.values(), Consumo_Top_Client__c.fields.Chiave__c, true);

            return 'success';

        }catch(Exception e){
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') && e.getMessage().contains('La somma dei consumi eccede il valore dichiarato nella soluzione'))    
                return 'error_totale_consumi';
            return 'error';
        }
    }
}