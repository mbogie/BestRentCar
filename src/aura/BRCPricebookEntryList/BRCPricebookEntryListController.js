({
   BRCPassPricebookEvent: function(component, event, helper) {
       helper.initEntryList(component, event,helper);
       component.set("v.selectedIndex", -1);
       component.set("v.blockButtons", false);
   },

    deleteItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
    	let action = component.get("c.deleteEntry");
    	action.setParams({
            "entryId": entryList[index].Id
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                helper.reloadEntryList(component, event,helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    editItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        component.set("v.selectedIndex", Number(index));
        component.set("v.blockButtons", true);
    },

    undoItem: function(component, event, helper) {
        component.set("v.selectedIndex", -1);
        component.set("v.blockButtons", false);
        helper.reloadEntryList(component, event,helper);
    },

    saveItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
        let entry = entryList[index];
        if(entry.UnitPrice == null || entry.UnitPrice >= entry.Standard_Price__c || entry.UnitPrice <= 1){
            component.find("toastCmp").showToastModel('Discount Price must be less then standard price and higher than 0', "error");
        } else {
    	let action = component.get("c.upsertEntry");
    	action.setParams({
            "pricebookEntry": entry
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                component.set("v.selectedIndex", -1);
                component.set("v.blockButtons", false);
                helper.reloadEntryList(component, event,helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
        }
    },

    navigateToRecord: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
        let entry = entryList[index];
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": entry.Product2Id
        });
        navEvt.fire();
    },

})