({
    doInit: function(component, event, helper) {
        helper.initPoster(component, event,helper);
    },

    navigateToRecord: function(component, event, helper) {
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let recordId = component.get("v.simpleRecord").Id;
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        "url": prefixSite + "/detail/" + recordId
        });
        urlEvent.fire();
    },
})