({
    doInit : function(component, event,helper) {
        helper.initPrice(component, event,helper);
    },

    addToBasket: function(component, event, helper) {
        let recordItem = component.get("v.productItem");
        let priceList = component.get("v.priceList");
        let objectItem = {
            price: priceList,
           product: recordItem
        };
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let cartJson = sessionStorage.getItem('cart'+userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
            console.log('add to list');
            let basketList = JSON.parse(cartJson);
            basketList.push(objectItem);
            console.log(basketList);
            sessionStorage.setItem('cart'+userId, JSON.stringify(basketList));
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Product_Added_to_Cart}"), "info");
        } else {
            console.log('new list2');
            let basketList = [objectItem];
            console.log(basketList);
            sessionStorage.setItem('cart'+userId, JSON.stringify(basketList));
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Product_Added_to_Cart}"), "info");
        }
    },

})