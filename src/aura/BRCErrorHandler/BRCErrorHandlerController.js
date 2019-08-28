({
    doInit : function(component, event, helper) {
         var params = event.getParam( 'arguments' );
            component.find('notifLib').showToast({
                        "variant": params.messageType,
                        "message": params.message,
                        "mode": "dismissable"
        });
     },
})