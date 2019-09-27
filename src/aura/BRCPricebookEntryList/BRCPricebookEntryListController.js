({
    BRCPassPricebookEvent: function(component, event, helper) {
        let pricebook = event.getParam("pricebook");
        helper.initEntryList(component, event, pricebook);
        helper.initSelectOptions(component, event, helper);
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
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                let pricebook = component.get("v.pricebook");
                helper.initEntryList(component, event, pricebook);
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
        helper.resetAttributes(component, event, helper);
        let pricebook = component.get("v.pricebook");
        helper.initEntryList(component, event, pricebook);
    },

    saveItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
        let entry = entryList[index];
        if (!entry.UnitPrice || entry.UnitPrice >= entry.Standard_Price__c || entry.UnitPrice <= 0) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Amount_Error}"), "error");
        } else {
            let action = component.get("c.upsertEntry");
            action.setParams({
                "pricebookEntry": entry
            });
            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
                    let pricebook = component.get("v.pricebook");
                    helper.initEntryList(component, event, pricebook);
                    helper.resetAttributes(component, event, helper);
                } else {
                    component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },

    addProductsToPricebook: function(component, event, helper) {
        helper.resetAttributes(component, event, helper);
        let pricebook = component.get("v.pricebook");
        helper.initEntryList(component, event, pricebook);
        component.set("v.openModal", true);
    },

    addPricebookEntityList: function(component, event, helper) {
        let selectedOption = component.get("v.selectProductsOption");
        let selectProductsOptions = component.get("v.selectProductsOptions");
        let pricebook = component.get("v.pricebook");
        let product = component.get("v.searchedProduct");
        if (selectedOption == selectProductsOptions[1] && !product.Brand__c) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Brand}"), "error");
        } else if (selectedOption == selectProductsOptions[2] && !product.ProductCode) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Field_Error}"), "error");
        } else {
            let action = component.get("c.addProducts");
            action.setParams({
                "discountType": pricebook.Discount_Type__c,
                "selectedOption": selectedOption,
                "pricebookId": pricebook.Id,
                "product": product,
                "price": pricebook.Discount_Amount__c,
            });
            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
                    helper.resetAttributes(component, event, helper);
                    helper.initEntryList(component, event, pricebook);
                } else {
                    component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },

    closeModel: function(component, event, helper) {
        helper.resetAttributes(component, event, helper);
        let pricebook = component.get("v.pricebook");
        helper.initEntryList(component, event, pricebook);
    },

    changeProductsType: function(component, event, helper) {
        let products = component.find("productSelect").get("v.value");
        component.set("v.selectProductsOption", products);
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