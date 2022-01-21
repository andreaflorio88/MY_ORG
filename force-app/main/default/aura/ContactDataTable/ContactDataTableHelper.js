({
	getContact : function(component, event, helper) {
		var action = component.get("c.getContacts");
        action.setParams({
            recordId: component.get("v.recordId")
        });
		action.setCallback(this, function(data) {
            component.set("v.contacts", data.getReturnValue());
        });
		$A.enqueueAction(action);
	},
    
    saveButton : function(component, event, helper) {
        var action = component.get("c.updateContact");
        action.setParam({ 
            editedContactList : component.get("v.contacts")
        });
        action.setCallback(this,function(response) {
           //component.set("v.contacts",response.getReturnValue());
           var state = response.getState();
            if (state === "SUCCESS") {
                
                var contacts = component.get("v.contacts");
                contacts.push(response.getReturnValue());
                component.set("v.contacts", contacts);
                
                
                console.log('+++++' + response.getReturnValue());
                var resultsToast = $A.get("e.force:showToast");
            	resultsToast.setParams({
                	title: "Saved",
                	message: "contact updated.",
                	type: "success"
            });
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
            }
            else
            {
                 alert("ERROR");
            }
        });
    $A.enqueueAction(action);
    },
    
})