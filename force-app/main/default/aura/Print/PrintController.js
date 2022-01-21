({
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
      window.print();
      setTimeout(() => {$A.get("e.force:closeQuickAction").fire();},0)
   }
})