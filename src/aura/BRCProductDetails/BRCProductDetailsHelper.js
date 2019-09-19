({
    initImages: function(component, event, helper) {
        let action = component.get("c.getProductImages");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.listOfImageUrls", response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    initFieldLabels: function(component, event, helper) {
        let action = component.get("c.getObjectFieldsLabels");
        action.setParams({
            "objectName": "Product2"
        });
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === 'SUCCESS') {
                component.set("v.fieldLabels", response.getReturnValue());
                console.log(response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})