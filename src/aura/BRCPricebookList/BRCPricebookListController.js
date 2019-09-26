({
    doInit: function(component, event, helper) {
        helper.initList(component, event, helper);
        let currentDate = new Date().toISOString().slice(0, 10);
        component.set("v.currentDate", currentDate);
    },

    deleteItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let pricebookList = component.get("v.pricebookList");
        let action = component.get("c.deletePb");
        action.setParams({
            "pricebookId": pricebookList[index].Id
        });
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                let selectedPricebook = component.get("v.selectedPricebook");
                helper.initList(component, event, helper);
                if (selectedPricebook == Number(index)) {
                    let action = $A.get("e.c:BRCPassPricebookEvent");
                    action.setParams({
                        "pricebook": null
                    });
                    action.fire();
                }
                component.set("v.selectedPricebook", -1);
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
        helper.initList(component, event, helper);
    },

    saveItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let pricebookList = component.get("v.pricebookList");
        let pricebook = pricebookList[index];
        let currentDate = new Date().toISOString().slice(0, 10);
        if (pricebook.End_Date__c == null || pricebook.Start_Date__c == null) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Field_Error}"), "error");
        } else if (pricebook.End_Date__c < currentDate) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_EndDate_Error}"), "error");
        } else if (pricebook.Start_Date__c > pricebook.End_Date__c) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_EndDate_Error}"), "error");
        } else {
            let action = component.get("c.upsertPb");
            action.setParams({
                "pricebook": pricebook
            });
            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
                    component.set("v.pricebookId", response.getReturnValue());
                    component.set("v.selectedIndex", -1);
                    component.set("v.blockButtons", false);
                } else {
                    component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },

    openDetails: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let pricebookList = component.get("v.pricebookList");
        component.set("v.selectedPricebook", Number(index));
        let action = $A.get("e.c:BRCPassPricebookEvent");
        action.setParams({
            "pricebook": pricebookList[index]
        });
        action.fire();
    },
})