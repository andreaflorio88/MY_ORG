({
    /* Fetch dell'owner corrente del case + 
     * fetch di tutti gli owner possibili per assistenza clienti:
     * utenti con profilo assistenza e code di 2° livello JIRA e non */
    doInit : function(component, event, helper) {
        helper.fetchCurrentOwner(component, event);
        helper.fetchAllOwners(component, event);
    },
    
    /* Apertura della dropdown di selezione +
     * ritaglio delle opzioni di assegnazione disponibili in base alla
     * stringa parziale digitata */
    handleKeyDown : function(component, event, helper) {
        var cmpTarget = component.find('dropDownElement');
        $A.util.addClass(cmpTarget, 'slds-is-open');
        
        var inputValue = component.find("ownerInput").getElement().value;
        var allOwnersTemp = component.get("v.possibleOwners").filter(owner => owner.ownerName.toUpperCase().includes(inputValue.toUpperCase()));                  
        
        component.set("v.possibleOwnersTemp", allOwnersTemp);        
    }, 
    
    /* Prima invocazione di cambio owner:
     * se l'owner non è una coda JIRA di 2° livello la 
     * modifica avviene subito, altrimenti 
     * viene chiamato JIRA dall' helper */
    handleOptionClick : function(component, event, helper){
        component.set("v.showSpinner", true);
        
        var setOwnerId = component.get("c.setOwner");
        var caseId = component.get("v.recordId");
        var ownerId = component.get("v.possibleOwnersTemp")[event.currentTarget.id].ownerId;
        
        setOwnerId.setParams({
            "caseId": caseId,
            "ownerId": ownerId
        });        
        
        setOwnerId.setCallback(this, function(response) {
            
            var state = response.getState();              
            
            if(state === "SUCCESS") {                 
                
                var result = response.getReturnValue();
                
                //OK
                if(result.status == 'OK'){
                    
                    component.find('notifLib').showToast({
                        "title": $A.get("$Label.c.Saved"),
                        "message": result.message,
                        "variant": "success"
                    });
                    
                    helper.fetchCurrentOwner(component, event);
                    component.set("v.showSpinner", false);
                    $A.get("e.force:refreshView").fire();  
                  
                //KO
                }else if(result.status == 'KO'){
                    
                    component.find('notifLib').showToast({
                        "title": $A.get("$Label.c.NotSaved"),
                        "message": result.message,
                        "variant": "error"
                    });
                    
                    component.set("v.showSpinner", false); 
                    
                }             
            }else{
                console.log(JSON.stringify(response.getError()));
            } 
        });
        
        $A.enqueueAction(setOwnerId);
    },
    
    /* Auto assegnazione del case - per risparmiare tempo
     * anzichè cercarsi tra i possibili owner */
    autoAssign : function(component, event, helper) {        
        helper.assignToMe(component, event);        
    },
    
    /* Apertura dell'inputField di modifica owner */
    openChangeOwner : function(component, event, helper) {        
        component.set("v.showEditField", true);        
    },
    
    /* Chiusura dell'inputField di modifica owner */
    closeChangeOwner : function(component, event, helper){        
        component.set("v.showEditField", false);
    }
})