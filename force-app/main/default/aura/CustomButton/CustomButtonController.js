/* CustomButtonController.js */
({
  fireComponentEvent: function (component, event) {
    var compEvent = component.getEvent("cmpEvent");
    compEvent.setParams({"message" : "Clicco e visualizzo questo messaggio"});
    //alert(compEvent.getParam("message"));
	compEvent.fire(); 
  }
})