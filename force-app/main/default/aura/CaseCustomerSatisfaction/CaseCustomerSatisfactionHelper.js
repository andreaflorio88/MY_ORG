({
    /* Fetch del valore iniziale di soddisfazione del cliente */
    getSatisfactionLevel : function(component, event) {
        var caseId = component.get("v.recordId");
        var setCS = component.get("c.getCustomerSatisfaction");
        
        setCS.setParams({
            "caseId": caseId         
        });        
        
        setCS.setCallback(this, function(response) {
            
            var state = response.getState();              
            
            if(state === "SUCCESS") {                 
                if(response.getReturnValue() == 3)
                    $A.util.addClass(component.find("svg_positive"), "positive");                
                if(response.getReturnValue() == 2)
                    $A.util.addClass(component.find("svg_neutral"), "neutral");
                if(response.getReturnValue() == 1)
                    $A.util.addClass(component.find("svg_negative"), "negative");
            }else{
                console.log(JSON.stringify(response.getError()));
            } 
        });
        
        $A.enqueueAction(setCS);
    },
    
    /** Set del valore di soddisfazione del ticket +
     *  Set del valore di soddisfazione del cliente  **/
    setSatisfactionLevel : function(component, event, level) {
        var caseId = component.get("v.recordId");
        var setCS = component.get("c.setCustomerSatisfaction");
        component.set("v.showSpinner", true);
        component.set("v.showError", false);
        
        setCS.setParams({
            "caseId": caseId,
            "satisfaction": level            
        });        
        
        setCS.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS") {
                if(level == 3){
                    $A.util.addClass(component.find("svg_positive"), "positive");
                    $A.util.removeClass(component.find("svg_neutral"), "neutral");
                    $A.util.removeClass(component.find("svg_negative"), "negative");         
                }
                else if(level == 2){
                    $A.util.removeClass(component.find("svg_positive"), "positive");
                    $A.util.addClass(component.find("svg_neutral"), "neutral");
                    $A.util.removeClass(component.find("svg_negative"), "negative");
                }
                else{
                    $A.util.removeClass(component.find("svg_positive"), "positive");
                    $A.util.removeClass(component.find("svg_neutral"), "neutral");
                    $A.util.addClass(component.find("svg_negative"), "negative");
                }
                component.set("v.showSpinner", false);  
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
        
        $A.enqueueAction(setCS);
    },
    
    /* Incremento del numero di solleciti ricevuti sul case */
    sollecito : function(component, event){
       
        var caseId = component.get("v.recordId");
        
        var remind = component.get("c.sollecita");
        
         remind.setParams({
            "caseId": caseId          
        });
        
        remind.setCallback(this, function(response) {
            
            var state = response.getState();              
            
            if(state === "SUCCESS") {                 
               $A.get('e.force:refreshView').fire();
            }else{
                console.log(JSON.stringify(response.getError()));
            } 
        });
        
        $A.enqueueAction(remind);
        
    }
})