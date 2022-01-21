({
    /*
    validateContactForm: function(component) {
        var validContact = true;
        // Show error messages if required fields are blank
        var allValid = component.find('contactField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            // Verify we have an account to attach it to
            var account = component.get("v.account");
            if($A.util.isEmpty(account)) {
                validContact = false;
                console.log("Quick action context doesn't have a valid account.");
            }
            return(validContact);
        }
    }*/
    enabledSaveButton : function(component, event, helper){	
        var phone = component.get("v.newContact.Phone");
        var mobilephone = component.get("v.newContact.MobilePhone");
        var button = component.find("saveButton");
        if(!component.find("firstname").checkValidity() || !(component.find("lastname").checkValidity())
           || ($A.util.isEmpty(phone) && $A.util.isEmpty(mobilephone)) || !component.find("phoneId").checkValidity() || !component.find("mphoneid").checkValidity())
        {
            button.set("v.disabled",true);
            
        }
        else
        {
            button.set("v.disabled",false);
        }
    },
      checkAndConfirm: function(cmp, evt){
        var checkResult = this.checkBeforeConfirm(cmp, evt);
        if(checkResult.errorFinded)
        {
            cmp.set("v.alertfirst",true);
            //cmp.set("v.newContact.Phone", "Inserisci numero");
        }
        else
        {
            this.saveContact(cmp, evt);
        }
    },
    checkBeforeConfirm: function(cmp, evt){
        var validationObj = {"errorFinded" : false, "errorsList":[]};
        var phone = cmp.get("v.newContact.Phone");
        var mobilephone = cmp.get("v.newContact.MobilePhone");
        
        
        if(cmp.find("firstname").checkValidity()== false || cmp.find("lastname").checkValidity()== false )
        {
            validationObj.errorFinded = true;
            validationObj.errorsList.push('Inserisci nome e cognome');
            
            
        } else if ($A.util.isEmpty(phone) && $A.util.isEmpty(mobilephone))
        {
       		validationObj.errorFinded = true;
            validationObj.errorsList.push('Inserisci un numero tra mobile e phone');
        }
        return validationObj;
    },
   saveContact: function(component, event){
        var saveContactAction = component.get("c.saveNewContact");
        saveContactAction.setParams({
            "contact": component.get("v.newContact"),
            "accountId": component.get("v.recordId")
        });
        // Configure the response for the action
        saveContactAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    title: "Contact Saved",
                    message: "The new contact was created."   
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                
            }
            else if (state === "ERROR") {
                component.set("v.alert",true);
                
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
        });
        // Send the request to create the new contact
        $A.enqueueAction(saveContactAction);
    }
})