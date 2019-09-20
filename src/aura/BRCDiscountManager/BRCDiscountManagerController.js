({
    createPricebook: function(component, event, helper) {
        let pricebook = component.get("v.pricebook");
        if(pricebook.Start_Date__c > pricebook.End_Date__c){
            component.find("toastCmp").showToastModel('Wrong Date', "error");
        } else {
    	let action = component.get("c.createPb");
    	action.setParams({
            "pricebook": pricebook
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                let reload = $A.get("e.c:BRCReloadPricebookListEvent");
                reload.fire();
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
        }
    },
})