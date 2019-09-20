({
    changeDay: function(component, productItem) {
        let productIndex = component.get("v.index");
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let cartJson = sessionStorage.getItem("cart" + userId);
        let basketList = JSON.parse(cartJson);
        component.set("v.productListItem", productItem);
        basketList[productIndex] = productItem;
        sessionStorage.setItem("cart" + userId, JSON.stringify(basketList));
        let action = $A.get("e.c:BRCRefreshCartListEvent");
        action.setParams({
            "onlyTotalCost": true
        });
        action.fire();
    },
})