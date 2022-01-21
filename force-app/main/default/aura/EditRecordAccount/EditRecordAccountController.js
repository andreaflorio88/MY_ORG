({
    saveAccount : function(cmp, event, helper) {
        var recordLoader = cmp.find("recordLoader");
        recordLoader.saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "ERROR") {
                var errMsg = "";
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                cmp.set("v.recordSaveError", errMsg);
            } else {
                cmp.set("v.recordSaveError", "");
            }  
        }));
    },
    recordUpdated: function(cmp, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title: "Saved",
                message: "The record was updated.",
                type: "info"
            });
            resultsToast.fire();
        } 
    }
})