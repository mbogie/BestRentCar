({
    doInit : function(component, event, helper) {
    		let action = component.get( "c.getAccountFieldsLabels" );
    		action.setParams({
                   obj: "Account"
                   });
            action.setCallback( helper, function( response ) {
                if ( component.isValid() && response.getState() === 'SUCCESS' ) {
                    component.set("v.searchFieldLabels", response.getReturnValue());
                    console.log(response.getReturnValue());
                } else {
                    console.error( actionName + ' ' + response.getState() );
                }
            });
            $A.enqueueAction( action );
    	},

    searchDivision : function(component, event, helper) {
       var action = component.get("c.getAccounts");
       action.setParams({
       country: component.get("v.searchedDivision.BillingCountry"),
       state: component.get("v.searchedDivision.BillingState"),
       city: component.get("v.searchedDivision.BillingCity"),
       });
       action.setCallback(this, function(response){
       if ( component.isValid() && response.getState() === 'SUCCESS' ) {
               var divisions = response.getReturnValue();
               var markers = divisions.map(function(account){
                    var marker = {
                            location: {
                               Street: account.BillingStreet,
                               City: account.BillingCity,
                               PostalCode: account.BillingPostalCode,
                               State: account.BillingState,
                               Country: account.BillingCountry
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
        } else {
             console.error( actionName + ' ' + response.getState() );
        }
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