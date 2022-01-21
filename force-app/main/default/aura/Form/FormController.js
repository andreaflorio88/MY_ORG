({ 
    /* AccHandlerCMPController.js */
    handleComponentEvent : function(cmp, event) {
    // Get value from Event
    var accRec = event.getParam("message");
    // set the handler attributes based on event data
    cmp.set("v.messageFromEvent", accRec);
    }
})