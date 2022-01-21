({
	doInit : function(component, event, helper) {
        var data = component.get("v.data");
        var columsList = component.get("v.columsList");
        var columnDatas = [];
        for(var c of columsList)
        {
            if(!$A.util.isEmpty(data) && !$A.util.isEmpty(c))
            {
                columnDatas.push(data[c]);
            }
        }
        component.set("v.dataColums", columnDatas);
	},
    
    setFirstName: function(component, event, helper) {
       	var data = component.get("v.data");
        data["FirstName"] = "TEST";
        component.set("v.data", data);
        var compEvent = component.getEvent("dataChanged");
        // Optional: set some data for the event (also known as event shape)
        // A parameter’s name must match the name attribute
        // of one of the event’s <aura:attribute> tags
        compEvent.setParams({
                "rowIndex" : component.get("v.myindex"), 
                "data" : data 
        });
        compEvent.fire();
        
    },
    
    edit : function (component, event, helper) {
        component.set("v.EditMode",true);
        setTimeout(function(){
            component.find("inputId").display;
        },100)
    }

})