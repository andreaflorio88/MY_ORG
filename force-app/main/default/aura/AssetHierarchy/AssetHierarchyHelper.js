({
    init : function (cmp, event, helper) {
    var action = cmp.get("c.getTreeData");
        action.setParams({
            recordId: cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.items', JSON.parse(response.getReturnValue()));
            }
            
        });
        $A.enqueueAction(action);
    },
    
	select : function(cmp, event, helper) {
	//var myName = event.getParam('name');
    //alert("You selected: " + myName); 

    var url = 'https://prova123-dev-ed.my.salesforce.com/' + event.getParam('name');
    var form = document.createElement("form");
    form.setAttribute("method", "POST");
    // open new page
    //form.setAttribute("target", "_blank"); 				
    form.setAttribute("action", url);
    document.body.appendChild(form);
	form.submit();	
	}
})