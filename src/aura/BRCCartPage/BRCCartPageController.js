({
    doInit: function(component, event, helper) {
        helper.initList(component, event, helper);
        helper.initTotalPrice(component, event, helper);
        helper.initUserAddress(component, event, helper);
    },

    clearCart: function(component, event, helper) {
        let userId = component.get("v.userId");
        sessionStorage.removeItem('cart' + userId);
        component.set("v.emptyCard", true);
    },

    BRCRefreshCartListEvent: function(component, event, helper) {
        let onlyCost = event.getParam("onlyTotalCost");
        if (onlyCost) {
            helper.initTotalPrice(component, event, helper);
        } else {
            helper.initList(component, event, helper);
            helper.initTotalPrice(component, event, helper);
        }
    },

    order: function(component, event, helper) {
        helper.doOrder(component, event, helper);
    },
})