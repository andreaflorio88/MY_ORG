({
	saveMethod : function(component, event, helper) {
		console.log('start method');
        var accId = component.find('ReAura').get('v.recordId');
        var accName = component.find('AuraName').get('v.value');
        var accPhone = component.find('AuraPhone').get('v.value');
        var accFax = component.find('AuraFax').get('v.value');
        var accEmail = component.find('AuraEmail').get('v.value');
        var accType = component.find('AuraType').get('v.value');
        var accAsset = component.find('AuraAsset').get('v.value');
        var action = component.get('c.saveRecords');
        console.log('ID: '+accId);
        console.log('NAME: '+accName);
        console.log('PHONE: '+accPhone);
        console.log('FAX: '+accFax);
        console.log('EMAIL: '+accEmail);
        action.setParams({"accountId":accId,"name":accName,"phone":accPhone, "fax":accFax,"email":accEmail,"type":accType,"asset":accAsset});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state'+ state);
            if(state === "SUCCESS") {
            console.log('state' + state);
            var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
        			"message": "The record has been updated successfully."
                });
            $A.get('e.force:closeQuickAction').fire();
                resultsToast.fire();
            $A.get('e.force:refreshView').fire();
            }  else {
                console.log('There was a problem : '+response.getError());
            }
        })
        $A.enqueueAction(action);
	}
})