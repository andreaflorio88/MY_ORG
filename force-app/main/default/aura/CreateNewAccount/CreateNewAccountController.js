({
    doInit : function(component, event, helper) {
        // Prepare the action to load account record
        
        var action = component.get("c.getAccount");
        action.setParams({"accountId": component.get("v.recordId")});
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.account", response.getReturnValue());
                helper.enabledSaveButton(component, event, helper);
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    canEnabledButton : function(component, event, helper) {
        	  helper.enabledSaveButton(component, event, helper);
    },
    
    saveContact: function(component, event, helper) {
        	helper.checkAndConfirm(component, event);        
    }
    
})