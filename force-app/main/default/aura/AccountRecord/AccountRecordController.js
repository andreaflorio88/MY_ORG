({
    doInit : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Event Name', fieldName: 'Subject', type: 'text'},
            {label: 'Start Date & Time', fieldName: 'StartDateTime', type: 'date'},
            {label: 'End Date & Time', fieldName: 'EndDateTime', type: 'date'},
            {type: "button", typeAttributes: {
                label: 'View',
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'view',
                iconPosition: 'left'
            }},
            {type: "button", typeAttributes: {
                label: 'Edit',
                name: 'Edit',
                title: 'Edit',
                disabled: false,
                value: 'edit',
                iconPosition: 'left'
            }}
        ]);
        
        var action = component.get("c.eventList");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.gridData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    viewRecord : function(component, event, helper) {
        var recId = event.getParam('row').Id;
        var actionName = event.getParam('action').name;
        if ( actionName == 'Edit' ) {
            alert(recId);
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId": recId
            });
            editRecordEvent.fire();
        } else if ( actionName == 'View') {
            alert(recId);
            var viewRecordEvent = $A.get("e.force:navigateToURL");
            viewRecordEvent.setParams({
                "url": "/" + recId
            });
            viewRecordEvent.fire();
        }
    }

})