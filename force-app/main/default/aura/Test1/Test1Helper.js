({
    getAccountHelper : function(component,event,defaultListView) {
        var selected;
        if(defaultListView == null){
            selected = component.find("selectedViewId").get("v.value");
        }else{
            selected = defaultListView;
        }
        var action = component.get("c.getFilteredAccounts");
        action.setParams({filterId : selected});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.AccountList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    }
})