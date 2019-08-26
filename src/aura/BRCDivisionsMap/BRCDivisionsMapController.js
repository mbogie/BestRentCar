({
    BRCPassMapMarkersEvent: function(component, event, helper) {
        let markers = event.getParam("markers");
        component.set('v.mapMarkers',markers);
        if ( markers.length == 1 ){
           component.set('v.zoomLevel', 13);
        } else if ( markers.length > 5 ){
           component.set('v.zoomLevel', 3);
        } else {
           component.set('v.zoomLevel', 4);
        }
    },
})