({    
    /* Metodo per la gestione dell'evento di Render */
    onRender : function(component, event, helper) {
         helper.getSatisfactionLevel(component, event);
    },
    
    /* Metodo per la gestione dell'assegnazione di un valore positivo */
    handleCustomerPositive : function(component, event, helper) {        
        helper.setSatisfactionLevel(component, event, 3);
    },

	/* Metodo per la gestione dell'assegnazione di un valore neutro */    
    handleCustomerNeutral : function(component, event, helper) {
        helper.setSatisfactionLevel(component, event, 2);
    },
    
    /* Metodo per la gestione dell'assegnazione di un valore negativo */
    handleCustomerNegative : function(component, event, helper) {
        helper.setSatisfactionLevel(component, event, 1);
    },
    
    /* Metodo per la gestione del sollecito ticket*/
    handleSollecito : function(component, event, helper) {
        helper.sollecito(component, event, 1);
    }
})