({
    initEntryList : function(component, event,helper) {
        let pricebook = event.getParam("pricebook");
        component.set("v.pricebook", pricebook);
        if(pricebook == null){
            component.set("v.emptyList", true);
        } else {
        component.set("v.pricebookId", pricebook.Id);
    	let action = component.get("c.getPricebookEntries");
    	action.setParams({
            "pricebookId": pricebook.Id
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                let entryList = response.getReturnValue();
                component.set("v.pricebookEntryList", entryList);
                component.set("v.emptyList", false);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
        }
    },

    reloadEntryList : function(component, event,helper) {
        let pricebookId = component.get("v.pricebookId");
    	let action = component.get("c.getPricebookEntries");
    	action.setParams({
            "pricebookId": pricebookId
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                let entryList = response.getReturnValue();
                component.set("v.pricebookEntryList", entryList);
                component.set("v.emptyList", false);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    resetAttributes : function(component, event,helper) {
        component.set("v.selectedIndex", -1);
        component.set("v.blockButtons", false);
        component.set("v.openModal",false);
        component.set("v.selectProductsOption", "All");
        component.set("v.searchedProduct",{});
        helper.reloadEntryList(component, event,helper);
    },
})