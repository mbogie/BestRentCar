({
    doInit : function(component, event, helper) {
    		let action = component.get( "c.getObjectFieldsLabels" );
    		action.setParams({
                   objectName: "Account"
                   });
            action.setCallback( this, function( response ) {
                if ( component.isValid() && response.getState() === 'SUCCESS' ) {
                    component.set("v.searchFieldLabels", response.getReturnValue());
                    console.log(response.getReturnValue());
                } else {
                    let errors = response.getError();
                    helper.handleErrors(errors);
                }
            });
            $A.enqueueAction(action);
    	},

    searchDivision : function(component, event, helper) {
       let action = component.get("c.getAccounts");
       action.setParams({
       country: component.get("v.searchedDivision.BillingCountry"),
       state: component.get("v.searchedDivision.BillingState"),
       city: component.get("v.searchedDivision.BillingCity"),
       });
       action.setCallback( this , function(response){
       if ( component.isValid() && response.getState() === 'SUCCESS' ) {
               let divisions = response.getReturnValue();
               let markers = divisions.map(function(account){
                    let marker = {
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
               helper.handleSuccess(divisions.length);
               let mapEvent = $A.get("e.c:BRCPassMapMarkersEvent");
               mapEvent.setParams({
                   "markers" : markers
                   });
               mapEvent.fire();
               console.log(markers);
               let listEvent = $A.get("e.c:BRCPassDivisionsListEvent");
               listEvent.setParams({
                           "divisions" : divisions
                           });
                       listEvent.fire();
        } else {
             let errors = response.getError();
             helper.handleErrors(errors);
        }
       });
       $A.enqueueAction(action);
    },

    clearDivision : function(component, event, helper) {
       component.set('v.searchedDivision', {});
       let listEvent = $A.get("e.c:BRCPassDivisionsListEvent");
       listEvent.setParams({
            "divisions" : []
             });
        listEvent.fire();
        let mapEvent = $A.get("e.c:BRCPassMapMarkersEvent");
        mapEvent.setParams({
             "markers" : []
        });
        mapEvent.fire();
        let detailEvent = $A.get("e.c:BRCClearDivisionDetailsEvent");
                detailEvent.setParams({
                     "division" : {}
                });
        detailEvent.fire();
    }
})