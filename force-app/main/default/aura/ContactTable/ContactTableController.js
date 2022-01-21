({
	doInit : function(component, event, helper) {
		var action = component.get("c.getContacts");
		action.setParams({
            recordId: component.get("v.recordId")
        });
		action.setCallback(this, function(data) {
            component.set("v.contacts", data.getReturnValue());
        });
		$A.enqueueAction(action);
	},
    showMessage: function(component, event){
        console.log("name changed");
    },
    
   	saveContactElement : function(component, event, helper) {
       		helper.saveContacts(component, event, helper);
    },
    
    cancel : function(component,event,helper){
    	var action = component.get("c.getContacts");
		action.setParams({
            recordId: component.get("v.recordId")
        });
		action.setCallback(this, function(data) {
            component.set("v.contacts", data.getReturnValue());
        });
		$A.enqueueAction(action);
    }
})