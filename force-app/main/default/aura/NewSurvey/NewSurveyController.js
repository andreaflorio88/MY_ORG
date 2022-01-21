({
	doInit : function(component, event, helper) {
         var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title: "Saved",
                message: "The record was updated.",
                type: "info"
            });
            resultsToast.fire();
	//setTimeout(() => {$A.get("e.force:closeQuickAction").fire();},0)	 
   
    
    // per nascondere il button prendere il suo id in component.find e inserire toogleClass --> slds-hide
    //var changeElement = component.find("saveButton");
    //$A.util.toggleClass(changeElement, "slds-hide");
    // per disabilitare un button basta settare v.disabled di lightning a true
    //button.set("v.disabled",true);
    }
})