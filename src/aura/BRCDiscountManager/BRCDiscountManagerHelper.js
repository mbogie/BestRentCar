({
    doReload: function(component, event, helper) {
        let discountTypes = component.get("v.discountTypes");
        let selectProductsOptions = component.get("v.selectProductsOptions");
        component.set("v.openModal", false);
        component.set("v.searchedProduct", {});
        component.set("v.discountType", discountTypes[0]);
        component.set("v.priceDiscount", 0);
        component.set("v.pricebook", {});
        component.set("v.selectProductsOption", selectProductsOptions[0]);
        component.set("v.reload", false);
        component.set("v.reload", true);
    },

    prepareValues: function(component, event, helper) {
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
        let discountTypesAction = component.get("c.getDiscountTypes");
        discountTypesAction.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                let discountTypes = response.getReturnValue();
                component.set("v.discountTypes", discountTypes);
                component.set("v.discountType", discountTypes[0]);
            } else {
                component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Server_Error}"), "error");
            }
        });
        $A.enqueueAction(discountTypesAction);
    },
})