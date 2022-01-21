({
    init: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'FirstName', fieldName: 'FirstName', type: 'text', editable: true},
            {label: 'LastName', fieldName: 'LastName', type: 'text',editable: true},
            {label: 'Email', fieldName: 'Email', type: 'email',editable: true},
            {label: 'Phone', fieldName: 'Phone', type: 'phone',editable: true}
           
        ]); 
    helper.getContact(component, event);
    },
    
    saveTable : function(component, event, helper){
        helper.saveButton(component, event, helper);
    }
    
})