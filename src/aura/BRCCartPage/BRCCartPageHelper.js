({
    initList: function(component, event, helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);
        let cartJson = sessionStorage.getItem("cart" + userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
            let basketList = JSON.parse(cartJson);
            component.set("v.productList", basketList);
            if (basketList.length === 0) {
                component.set("v.emptyCard", true);
            } else {
                component.set("v.emptyCard", false);
            }
        } else {
            component.set("v.emptyCard", true);
        }
    },

    initTotalPrice: function(component, event, helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);
        let cartJson = sessionStorage.getItem("cart" + userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
            let basketList = JSON.parse(cartJson);
            let totalPrice = 0;
            for (let obj in basketList) {
                totalPrice += basketList[obj].price.UnitPrice * basketList[obj].days;
            }
            component.set("v.totalPrice", totalPrice);
        }
    },

    initUserAddress: function(component, event, helper) {
        let action = component.get("c.getContractAddress");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                let user = response.getReturnValue();
                component.set("v.order.ShippingStreet", user.Address.street);
                component.set("v.order.ShippingPostalCode", user.Address.postalCode);
                component.set("v.order.ShippingCity", user.Address.city);
                component.set("v.order.ShippingState", user.Address.state);
                component.set("v.order.ShippingCountry", user.Address.country);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    doOrder: function(component, event, helper) {
        let userId = component.get("v.userId");
        let order = component.get("v.order");
        if (!order.ShippingStreet || !order.ShippingPostalCode || !order.ShippingCity || !order.ShippingState || !order.ShippingCountry) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Field_Error}"), "error");
        } else {
            let cartJson = sessionStorage.getItem("cart" + userId);
            let basketList = JSON.parse(cartJson);
            let action = component.get("c.createOrder");
            action.setParams({
                "newOrder": order,
                "wrapperList": cartJson
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    sessionStorage.removeItem('cart' + userId);
                    component.set("v.emptyCard", true);
                } else {
                    component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },
})