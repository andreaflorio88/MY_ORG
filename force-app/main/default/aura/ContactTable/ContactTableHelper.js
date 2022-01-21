({
    saveContacts : function (component, event, helper) {
        var saveContactAction = component.get("c.up");
        var clist = component.get("v.contacts");
        for(var k in clist ){
            
              console.log('contatti +++++' + clist[k].firstname);
        }
        
        saveContactAction.setParams({inputC : component.get("v.contacts")});
        saveContactAction.setCallback(this, function(response) {
   			var state = response.getState();
            console.log(state);
            if(state ==="SUCCESS"){
                console.log('+++++' + response.getReturnValue());
                component.set("v.contacts",response.getReturnValue());
                console.log(response.getReturnValue());
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
    $A.enqueueAction(saveContactAction);
    }
})