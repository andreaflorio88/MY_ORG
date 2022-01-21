({
	save : function(component, helper, event) {
		var actionS = component.get("c.saveSurvey");
        actionS.setParams({
            "survey": component.get("v.newSurvey"),
            "account__c" : component.get("v.recordId")
            });
         actionS.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.newSurvey", response.getReturnValue());
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    title: "Survey Saved",
                    message: "new survey",
                    type : "success"
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                
            }
            else if (state === "ERROR") {
                component.set("v.alert",true);
                
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
        });
        $A.enqueueAction(actionS);
    
	}
})