({
    initImages: function(component, event, helper) {
        let action = component.get("c.getProductImages");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                let listPath = response.getReturnValue();
                component.set("v.listOfImages", listPath.images);
                component.set("v.posterPath", listPath.poster);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    imageType: function(component, event, helper) {
        let recordId = component.get("v.recordId");
        let docId = event.getParam("files")[0].documentId;
        let setType = component.get("c.setImageType");
        setType.setParams({
            "documentId": docId,
            "imageType": "image",
            "recordId": recordId
        });
        setType.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                helper.initImages(component, event, helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(setType);
    },
})