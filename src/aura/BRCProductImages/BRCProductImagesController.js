({
    doInit: function(component, event, helper) {
        helper.initImages(component, event, helper);
    },

    handleUploadFinished: function(component, event, helper) {
        helper.imageType(component, event, helper);
        component.set("v.imageType", "image");
    },

    BRCReloadRecordPageEvent: function(component, event, helper) {
        helper.initImages(component, event, helper);
    },
})