({
    /* Fetch del nome dell'utente corrente da mostrare 
     * sul componente */
    fetchCurrentOwner : function(component, event) {
        component.set("v.showSpinner", true);
        var getON = component.get("c.getOwnerName");
        
        getON.setParams({
            "caseId": component.get("v.recordId")         
        });        
        
        getON.setCallback(this, function(response) {
            
            var state = response.getState();              
            
            if(state === "SUCCESS") {                 
                component.set("v.ownerName", response.getReturnValue());
                component.set("v.showSpinner", false);
            }else{
                console.log(JSON.stringify(response.getError()));
                component.set("v.showSpinner", false);
            } 
        });
        
        $A.enqueueAction(getON);
    },
    
    /* Fetch di tutti gli owner possibili del case (Assistenza clienti);
     * il fetch è one-time, poi il controller in base alla stringa digitata
     * filtra i risultati */
    fetchAllOwners: function(component, event) {
        var getOwners = component.get("c.getPossibleOwners");
        
        getOwners.setParams({
            "caseId": component.get("v.recordId")         
        });

        getOwners.setCallback(this, function(response) {
            
            var state = response.getState();              
            
            if(state === "SUCCESS") {                
                component.set("v.possibleOwners", response.getReturnValue());
            }else{
                console.log(JSON.stringify(response.getError()));
            } 
        });
        
        $A.enqueueAction(getOwners);
    }, 
    
    /* Auto assegnazione del case */
    assignToMe : function(component, event) {
        var selfAssign = component.get("c.selfAssign");
        
        component.set("v.showSpinner", true);
        
        selfAssign.setParams({
            "caseId": component.get("v.recordId")         
        });        
        
        selfAssign.setCallback(this, function(response) {
            
            var state = response.getState();              
            
            if(state === "SUCCESS") {                 
                component.set("v.ownerName", response.getReturnValue());
                component.set("v.showSpinner", false);
                $A.get("e.force:refreshView").fire();                 
            }
            else if(state === "ERROR"){
                component.set("v.showSpinner", false);
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].pageErrors[0]) {
                        if(errors[0].pageErrors[0].statusCode == "FIELD_CUSTOM_VALIDATION_EXCEPTION"){                            
                            
                            component.find('notifLib').showToast({
                                "title": $A.get("$Label.c.NotSaved"),
                                "message": errors[0].pageErrors[0].message,
                                "variant": "error"
                            });
                            
                        }
                        else
                            console.log(JSON.stringify(response.getError()));
                    }
                }                
            }
        });
        
        $A.enqueueAction(selfAssign);
    }
})