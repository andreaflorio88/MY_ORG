({
    doInit: function (cmp, event, helper) {
        cmp.set('v.gridColumns', [
            {label: 'name', fieldName: 'name', type: 'url', 
             typeAttributes: {label: { fieldName: 'name' }
                }},
            {label: 'status', fieldName: 'status', type: 'text'},
            {label: 'Install Date', fieldName: 'label', type: 'date'}
            ]);
        helper.getData(cmp);
    }
})