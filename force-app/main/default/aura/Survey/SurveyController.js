({
	doInit : function(component, event, helper) {
        var action = component.get("c.getAccount");
        action.setParams({"accountId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.account", response.getReturnValue());   
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveNewSurvey: function(component, event, helper) {
        	helper.save(component, event,helper);        
    }	
	
})