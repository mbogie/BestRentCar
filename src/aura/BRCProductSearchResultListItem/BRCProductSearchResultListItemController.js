({
    doInit: function(component, event, helper) {
        let action = component.get("c.getProductPoster");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.posterPath", response.getReturnValue());
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    navigateToRecord: function(component, event, helper) {
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let recordId = component.get("v.simpleRecord").Id;
        console.log(component.get("v.simpleRecord").Brand__c);
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        "url": prefixSite + "/detail/" + recordId
        });
        urlEvent.fire();
    },
})