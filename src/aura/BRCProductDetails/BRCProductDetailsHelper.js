({
    initImages : function(component, event,helper) {
        console.log(component.get("v.recordId"));
        let action = component.get("c.getProductImages");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
           // console.log(response.getState());
            if (response.getState() === "SUCCESS") {
                console.log(response.getReturnValue());
                let listPath = response.getReturnValue();
                component.set("v.listOfUrls", listPath.images);
                component.set("v.posterPath", listPath.poster);
            }
        });
        $A.enqueueAction(action);
    },

    initProfile : function(component, event,helper) {
        let getUserProfile = component.get("c.getUserProfile");
        getUserProfile.setCallback(this, function(response){
            console.log(response.getState());
            if (response.getState() === "SUCCESS") {
                component.set("v.userProfile", response.getReturnValue());
            //    console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(getUserProfile);
    },
})