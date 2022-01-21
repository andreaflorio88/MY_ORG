({
    /* Check dell'owner del case; se Owner JIRA,
     * set dell'url a cui fare le chiamate: SD/WoRC */
    doInit: function (component, event, helper) {
        helper.checkLock(component, event);
    },
    
    /* Alla chiusura del tab, il componente viene distrutto e 
     * viene rilasciato il lock del record (= sbiancato il campo isLockedBy) */
    handleDestroy: function(component, event, helper){
        helper.removeLock(component, event);
    },

    /* Chiusura del modale */    
    closeModal: function(component, event, helper){
        component.set("v.showModal", false);
    }
})