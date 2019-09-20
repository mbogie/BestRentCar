({
    initList : function(component, event,helper) {
    	let action = component.get("c.getAllPricebooks");
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                component.set("v.pricebookList", response.getReturnValue());
                console.log(response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})