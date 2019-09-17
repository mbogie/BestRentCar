({
    doInit: function(component, event, helper) {
        helper.initPoster(component, event,helper);
    },

    navigateToRecord: function(component, event, helper) {
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let recordId = component.get("v.resultItem").product.Id;
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        "url": prefixSite + "/detail/" + recordId
        });
        urlEvent.fire();
    },

    addToBasket: function(component, event, helper) {
        let objectItem = component.get("v.resultItem");
        let userId = $A.get("$SObjectType.CurrentUser.Id");
    }
})