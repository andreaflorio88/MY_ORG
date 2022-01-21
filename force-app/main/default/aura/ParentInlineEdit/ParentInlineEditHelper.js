({
    requiredFieldValidation : function(component,event) {
        var allRecords = component.get("v.AccountList");
        var isValid = true;
        for(var i = 0; i < allRecords.length;i++){
            if(allRecords[i].Name == null || allRecords[i].Name.trim() == ''){
                alert('fill this field : Row No ' + (i+1) + ' Account Name is null' );
                isValid = false;
            } 
        }
        return isValid;
    },
})