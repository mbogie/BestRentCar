({
    selectRecord : function(component, event, helper) {
           let division = component.get("v.division");
           console.log(division);
           let detailEvent = $A.get("e.c:BRCPassDivisionDetail");
           detailEvent.setParams({
                "division" : division
                });
           detailEvent.fire();
           let mapEvent = $A.get("e.c:BRCPassMapMarkers");
                mapEvent.setParams({
                     "markers" : [
                          {
                          location: {
                              Street: division.BillingStreet,
                              City: division.BillingCity,
                              PostalCode: division.BillingPostalCode,
                              State: division.BillingState,
                              Country: division.Country
                              },
                           title: division.Name,
                           }
                     ]
           });
           mapEvent.fire();
     },
})