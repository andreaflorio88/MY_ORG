({
    doInit : function(component, event, helper) {
        // call apex method to fetch list view dynamically 
        var action = component.get("c.listValues");
        action.setParams({
            "objectInfo" : component.get("v.objectInfo")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listViewResult = response.getReturnValue();
                if(listViewResult.length > 0){
                    // set listViewResult attribute with response
                    component.set("v.listViewResult",listViewResult);
                    // set first value as default value
                    component.set("v.currentListViewName", listViewResult[0].developerName);
                    // rendere list view on component
                    component.set("v.bShowListView", true);     
                }            } 
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    onPicklistChange: function(component, event, helper) {
        // unrenders listView 
        component.set("v.bShowListView", false); 
        
        // get current selected listview Name 
        var lstViewName = event.getSource().get("v.value"); 
        
        // set new listName for listView
        component.set("v.currentListViewName", lstViewName);
        
        // rendere list view again with new listNew  
        component.set("v.bShowListView", true); 
    },
})