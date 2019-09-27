({
    initEntryList: function(component, event, pricebook) {
        component.set("v.pricebook", pricebook);
        if (pricebook == null) {
            component.set("v.emptyList", true);
        } else {
            component.set("v.pricebookId", pricebook.Id);
            let action = component.get("c.getPricebookEntries");
            action.setParams({
                "pricebookId": pricebook.Id
            });
            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
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

    initSelectOptions: function(component, event, helper) {
        let optionsAction = component.get("c.getSelectProductsOption");
        optionsAction.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                let selectProductsOptions = response.getReturnValue();
                component.set("v.selectProductsOptions", selectProductsOptions);
                component.set("v.selectProductsOption", selectProductsOptions[0]);
            } else {
                component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Server_Error}"), "error");
            }
        });
        $A.enqueueAction(optionsAction);
    },

    resetAttributes: function(component, event, helper) {
        component.set("v.selectedIndex", -1);
        component.set("v.blockButtons", false);
        component.set("v.openModal", false);
        let selectProductsOptions = component.get("v.selectProductsOptions");
        component.set("v.selectProductsOption", selectProductsOptions[0]);
        component.set("v.searchedProduct", {});
    },
})