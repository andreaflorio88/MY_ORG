({
    /* Controllo che il case non sia già in visualizzazione per un altro utente,
     * se sì, viene presentato un messaggio con informazioni su chi sta visualizzando/lavorando sul record
     * e da quando */
    checkLock : function(component, event){
        
        var isLocked = component.get("c.checkAndSetLock");
        
         isLocked.setParams({
            "caseId": component.get("v.recordId")           
        });
        
        isLocked.setCallback(this, function(response) {
            
            var state = response.getState();            
            
            if(state === "SUCCESS"){
                
                var result = response.getReturnValue();
                
                if(result.isAlreadyLocked && result.lockString){
                    
                    var lockedBy = result.lockString.split('*')[1];
                    var lockedAt = result.lockString.split('*')[2];
                    
                    component.set("v.showModal", true);
                    component.set("v.lockedBy", lockedBy);
                    component.set("v.lockedAt", lockedAt);
                }
                
            }else
                console.log(JSON.stringify(response.getError()));
        });
        
        $A.enqueueAction(isLocked);
    },
    
    /* Rimozione del lock (= sbiancamento del campo isLockedBy) 
     * alla chiusura del tab */
    removeLock : function(component, event){
        
        var unlock = component.get("c.unsetLock");
        
         unlock.setParams({
            "caseId": component.get("v.recordId")           
        });
        
        $A.enqueueAction(unlock);
    }
})