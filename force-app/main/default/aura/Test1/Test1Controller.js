({
	
    doInit : function(component, event, helper){
        component.set('v.mycolumns', [
            {label: 'Contact Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'},
            {label: 'Created Date ', fieldName: 'CreatedDate', type: 'date'}
        ]);
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.AccountListViewList",response.getReturnValue());
                helper.getAccountHelper(component,event,response.getReturnValue()[0].Id);
            }
        });
        $A.enqueueAction(action); 
    },
    getFilteredAccount : function (component, event, helper) {
        helper.getAccountHelper(component,event,null);
    }

})