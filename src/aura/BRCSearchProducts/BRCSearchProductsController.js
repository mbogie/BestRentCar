({
    handleClick: function(component, event, helper) {
        helper.handleSearch(component, event, helper);
    },

    handleKeyUp: function(component, event, helper) {
        if (event.getParams().keyCode == 13) {
            helper.handleSearch(component, event, helper);
        }
    },

    showBasket: function(component, event, helper) {
        component.set("v.openCart", true);
    },

    closeBasket: function(component, event, helper) {
        component.set("v.openCart", false);
    },
})