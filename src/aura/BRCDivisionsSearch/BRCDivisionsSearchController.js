({
    searchDivision : function(component, event, helper) {
       var action = component.get("c.getAccounts");
       action.setParams({
       country: component.get("v.searchedDivision.ShippingCountry"),
       state: component.get("v.searchedDivision.ShippingState"),
       city: component.get("v.searchedDivision.ShippingCity"),

       });
       action.setCallback(this, function(response){
       var divisions = response.getReturnValue();
       var appEvent = $A.get("e.c:BRCGetDivisionsListEvent");
       appEvent.setParams({
                   "divisions" : divisions
                   });
               appEvent.fire();
       });
       $A.enqueueAction(action);
    },

    clearDivision : function(component, event, helper) {
       component.set('v.searchedDivision', {});
       var appEvent = $A.get("e.c:BRCGetDivisionsListEvent");
       appEvent.setParams({
            "divisions" : []
             });
        appEvent.fire();
    }
})