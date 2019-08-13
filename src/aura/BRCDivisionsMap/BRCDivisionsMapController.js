({
    init: function (component, event, helper) {
        var action = component.get("c.getAccount");
        action.setCallback(this, function(response) {
            console.log('response'+response);
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                var obj =response.getReturnValue() ;
                console.log(obj);
                component.set('v.center', {
                    location: {
                        City: 'Denver'
                    }
                });
                component.set('v.mapMarkers',[]);
                component.set('v.zoomLevel', 4);
                component.set('v.markersTitle', 'Salesforce locations');
                component.set('v.showFooter', true);
            }

        });
        $A.enqueueAction(action);
    }
})