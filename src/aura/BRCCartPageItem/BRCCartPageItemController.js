({
    changeDays: function(component, event, helper) {
        let productItem = component.get("v.productListItem");
        let days = productItem.days;
        if (days > 0) {
            helper.changeDay(component, productItem);
        } else {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Error_Wrong_Days_Number}"), "error");
            productItem.days = 1;
            component.set("v.productListItem", productItem);
        }
    },

    plusDay: function(component, event, helper) {
        let productItem = component.get("v.productListItem");
        let days = productItem.days;
        productItem.days = Number(days) + 1;
        helper.changeDay(component, productItem);
    },

    minusDay: function(component, event, helper) {
        let productItem = component.get("v.productListItem");
        let days = productItem.days;
        productItem.days = Number(days) - 1;
        helper.changeDay(component, productItem);
    },

    navigateToProduct: function(component, event, helper) {
        let productItem = component.get("v.productListItem");
        let recordId = productItem.product.Id;
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": prefixSite + "/detail/" + recordId
        });
        urlEvent.fire();
    },

    deleteItem: function(component, event, helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let productIndex = component.get("v.index");
        let cartJson = sessionStorage.getItem("cart" + userId);
        let basketList = JSON.parse(cartJson);
        basketList.splice(productIndex, 1);
        sessionStorage.setItem("cart" + userId, JSON.stringify(basketList));
        let action = $A.get("e.c:BRCRefreshCartListEvent");
        action.setParams({
            "onlyTotalCost": false
        });
        action.fire();
    },
})