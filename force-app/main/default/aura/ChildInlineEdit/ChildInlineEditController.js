({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Rating', 'ratingPicklistOpts');
    },
    EditName : function(component,event,helper){  
        component.set("v.nameEditMode", true);
        setTimeout(function(){
            component.find("inputId").focus();
        }, 100);
    },
    inlineEditRating : function(component,event,helper){  
        component.set("v.ratingEditMode", true);
        component.find("accRating").set("v.options" , component.get("v.ratingPicklistOpts"));
        setTimeout(function(){
            component.find("accRating").focus();
        }, 100);
    },
    onNameChange : function(component,event,helper){
        if(event.getSource().get("v.value").trim() != ''){
            component.set("v.showSaveCancelBtn",true);
        }
    },
    onRatingChange : function(component,event,helper){
        component.set("v.showSaveCancelBtn",true);
    },    
    closeNameBox : function (component, event, helper) {
        component.set("v.nameEditMode", false);
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    },
    closeRatingBox : function (component, event, helper) {
        component.set("v.ratingEditMode", false);
    },
})