({
    initList : function(component, event,helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);
        let cartJson = sessionStorage.getItem('cart'+userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
            let basketList = JSON.parse(cartJson);
            let totalPrice = 0;
            console.log(basketList);
            for (let obj in basketList){
                totalPrice += basketList[obj].price.UnitPrice * basketList[obj].days;
            }
            component.set("v.productList", basketList);
            component.set("v.totalPrice", totalPrice);
            component.set("v.emptyCard", false);
        } else {
            component.set("v.emptyCard", true);
        }
    },
})