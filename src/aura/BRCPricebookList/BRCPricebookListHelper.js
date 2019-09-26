({
    initList: function(component, event, helper) {
        let action = component.get("c.getAllPricebooks");
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                component.set("v.pricebookList", response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
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