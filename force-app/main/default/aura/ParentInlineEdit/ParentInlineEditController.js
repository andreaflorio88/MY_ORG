({
    getAccountsJS : function(component, event, helper) {
        var action = component.get("c.accountsToDisplay");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS" && component.isValid()) {
                component.set("v.AccountList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    SaveAccount : function(component, event, helper) {
        if (helper.requiredFieldValidation(component, event)){
            var action = component.get("c.saveAccount");
            action.setParams({
                'listOfAccount': component.get("v.AccountList")
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS" && component.isValid()) {
                    component.set("v.AccountList", response.getReturnValue());
                    component.set("v.showSaveCancelBtn",false);
                    alert('Account Updated...');
                }
            });
            $A.enqueueAction(action);
        }
    },
})