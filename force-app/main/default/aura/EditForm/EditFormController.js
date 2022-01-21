({
    save : function(component, event, helper) {
        helper.saveMethod(component, event, helper);
    },
    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})