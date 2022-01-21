({
	handleDataChanged : function(component, event, helper) {
		var datas = component.get("v.datas");
        var rowIndex = event.getParam("rowIndex");
        var data = event.getParam("data");
        datas[rowIndex] = data;
        component.set("v.datas", datas);
        
	}
})