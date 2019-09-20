({
    doInit: function(component, event, helper) {
        helper.initList(component, event, helper);
        helper.initTotalPrice(component, event, helper);
    },

    clearCart: function(component, event, helper) {
        let userId = component.get("v.userId");
        sessionStorage.removeItem('cart' + userId);
        component.set("v.productList", null);
        component.set("v.totalPrice", 0);
        let action = $A.get("e.c:BRCRefreshCartListEvent");
        action.setParams({
            "onlyTotalCost": false
        });
        action.fire();
    },

    deleteItem: function(component, event, helper) {
        let userId = component.get("v.userId");
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let productList = component.get("v.productList");
        productList.splice(index, 1);
        sessionStorage.setItem("cart" + userId, JSON.stringify(productList));
        helper.initList(component, event, helper);
        helper.initTotalPrice(component, event, helper);
        let action = $A.get("e.c:BRCRefreshCartListEvent");
        action.setParams({
            "onlyTotalCost": false
        });
        action.fire();
    },

    navigateToProduct: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let productList = component.get("v.productList");
        let recordId = productList[index].product.Id;
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": prefixSite + "/detail/" + recordId
        });
        urlEvent.fire();
    },

    goToCartPage: function(component, event, helper) {
        let navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({
            url: "/cart-page"
        });
        navEvt.fire();
    },
})