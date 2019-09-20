({
    onSelect: function(component, event, helper) {
        component.set("v.openModal", true);
    },

    closeModel: function(component, event, helper) {
        component.set("v.openModal", false);
    },

    deleteImage: function(component, event, helper) {
        helper.deleteImage(component, event, helper);
    },

    selectPoster: function(component, event, helper) {
        helper.selectPoster(component, event, helper);
    },
})