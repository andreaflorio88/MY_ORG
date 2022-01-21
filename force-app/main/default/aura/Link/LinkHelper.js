({   
    checkParameter : function(component) {
        var action = component.get("c.getParameter");
        action.setParams({"accountId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
        	if(state === "SUCCESS") {
                var result = response.getReturnValue();
                var resparsed = JSON.parse(result);
   				console.log('@@' + resparsed['Id']);
                //component.set('v.accountId', resparsed['Id']);
                component.set('v.qualtrics',"https://pmimsa.eu.qualtrics.com/jfe/form/SV_85DwkLtzhFhz9NH?U_PER="+ resparsed['Id']+
                              "&U_COU=IT&U_LAN=IT&U_CHA=c1Ab&U_TOU=t9Tu&U_DAT=" + resparsed['tod'] + "&U_DIR=&U_IND=&U_COA=");
                
            } 
        });
        $A.enqueueAction(action);
    }
})