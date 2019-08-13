({
    selectRecord : function(component, event, helper) {
           var division = component.get("v.division");
           console.log(division);
           var appEvent = $A.get("e.c:BRCGetDivisionDetailEvent");
           appEvent.setParams({
                       "division" : division
                       });
           appEvent.fire();
           var mapEvent = $A.get("e.c:BRCSetMapMarkerEvent");
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