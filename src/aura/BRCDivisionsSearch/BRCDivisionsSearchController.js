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
       var markers = divisions.map(function(account){
            var marker = {
                    location: {
                       Street: account.BillingStreet,
                       City: account.BillingCity,
                       PostalCode: account.BillingPostalCode,
                       State: account.BillingState,
                       Country: account.Country
                  },
                  title: account.Name,
                  }
            return marker;

       });
       var mapEvent = $A.get("e.c:BRCSetMapMarkerEvent");
                      mapEvent.setParams({
                                  "markers" : markers
                                  });
       mapEvent.fire();
       console.log(markers);
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
        var mapEvent = $A.get("e.c:BRCSetMapMarkerEvent");
        mapEvent.setParams({
             "markers" : []
        });
        mapEvent.fire();
        var detailEvent = $A.get("e.c:BRCClearDivisionDetails");
                detailEvent.setParams({
                     "division" : {}
                });
                detailEvent.fire();

    }
})