({
    init: function(component, event, helper) {
        var action = component.get("c.getUserRoles");
        action.setCallback(this, function(response) {
            var roles = {}, results;
            if(component.isValid() && response.getState() === "SUCCESS") {
                results = response.getReturnValue();
                roles[undefined] = { Name: "Root", items: [] };
                results.forEach(function(v) {
                    roles[v.Id] = { Name: v.Name, items: [] };
                });
                results.forEach(function(v) {
                        roles[v.ParentId].items.push(roles[v.Id]);
                });
                component.set("v.nodes", roles[undefined].items);
            } else {
                alert(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})