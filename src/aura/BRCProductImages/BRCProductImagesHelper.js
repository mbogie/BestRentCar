({
    initImages : function(component, event,helper) {
                console.log('init');

        let action = component.get("c.getProductImages");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                console.log(response.getReturnValue());
                let listPath = response.getReturnValue();
                component.set("v.listOfImages", listPath.images);
                component.set("v.posterPath", listPath.poster);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})