({
    initImages : function(component, event,helper) {
        let action = component.get("c.getProductImages");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
           // console.log(response.getState());
            if (response.getState() === "SUCCESS") {
             //   console.log(response.getReturnValue());
                let listPath = response.getReturnValue();
                component.set("v.listOfUrls", listPath.images);
                component.set("v.posterPath", listPath.poster);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    initProfile : function(component, event,helper) {
        let getUserProfile = component.get("c.getUserProfile");
        getUserProfile.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                component.set("v.userProfile", response.getReturnValue());
            //    console.log(response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(getUserProfile);
    },

    initFieldLabels : function(component, event,helper) {
    	let action = component.get("c.getObjectFieldsLabels");
    	action.setParams({
            objectName: "Product2"
            });
            action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === 'SUCCESS' ) {
                    component.set("v.fieldLabels", response.getReturnValue());
                  //  console.log(response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})