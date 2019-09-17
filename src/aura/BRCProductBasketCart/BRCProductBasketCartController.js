({
    doInit: function(component, event, helper) {
        helper.initList(component, event,helper);
    },

    clearCart: function(component, event, helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        sessionStorage.removeItem('cart'+userId);
        component.set("v.productList", null);
        component.set("v.totalPrice", 0);
    },
})