({
    doInit: function(component, event, helper) {
        helper.initList(component, event,helper);
        helper.initTotalPrice(component, event,helper);
    },

    clearCart: function(component, event, helper) {
        let userId = component.get("v.userId");
        sessionStorage.removeItem('cart'+userId);
        component.set("v.emptyCard", true);
    },

    BRCRefreshCartList: function(component, event, helper) {
        let onlyCost = event.getParam("onlyTotalCost");
        if (onlyCost){
            helper.initTotalPrice(component, event,helper);
        } else {
            helper.initList(component, event,helper);
            helper.initTotalPrice(component, event,helper);
        }
    },

    order: function(component, event, helper) {
        let userId = component.get("v.userId");
        let order = component.get("v.order");
        let cartJson = sessionStorage.getItem("cart"+userId);
        let basketList = JSON.parse(cartJson);
        let action = component.get("c.createOrder");
        action.setParams({
            "newOrder" : order,
            "wrapperList" : basketList
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
               sessionStorage.removeItem('cart'+userId);
               component.set("v.emptyCard", true);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})