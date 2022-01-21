/*
  Source : sfdcMonkey.com
  API : 45.00
  Date : 3/13/2019
*/
({
    fetchAccountDetails : function(component, event, helper) {
        // set table columns in variable
        var tableColumns = [
            {
                "label": "Id",
                "fieldName": "Id",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    },
                    "iconName": {
                        "fieldName": "displayIconName"
                    }
                }
            },
            {
                "label": "Account Name",
                "fieldName": "Name",
                "type": "url",
                "typeAttributes": {
                    "label": {
                        "fieldName": "Name"
                    },
                    "target": "_blank"
                },
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
            {
                "label": "Email",
                "fieldName": "Email__c",
                "type": "picklist",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
            {
                "label": "Account Type",
                "fieldName": "Type",
                "type": "picklist",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
            {label: 'Modifica', type: 'button', 
             typeAttributes: { label: 'Modifica', name: 'edit',
                              title: 'Invita un amico'}}
        ];
        // set tableCol attribute with table columns
        component.set('v.tableCol', tableColumns);
        
        // call server side apex method to fetch account records
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                // store the account list in records variable
                var records = response.getReturnValue();
                component.set("v.accountList", records); 
            }
        });
        $A.enqueueAction(action);
    }
})