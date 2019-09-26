({
    initPrice: function(component, event, helper) {
        let action = component.get("c.getPrice");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                component.set("v.priceList", result);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})