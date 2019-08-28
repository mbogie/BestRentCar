({
    doInit: function(component, event, helper) {
        console.log('aaa');
        let action = component.get("c.getProductImages");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
                    console.log(response.getState());
            if (response.getState() === "SUCCESS") {
                component.set("v.listOfUrls", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})