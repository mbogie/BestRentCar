({
    onSelect: function (component, event, helper) {
        component.set("v.openModal", true);
    },

    closeModel : function(component, event, helper) {
       component.set("v.openModal", false);
    },
})