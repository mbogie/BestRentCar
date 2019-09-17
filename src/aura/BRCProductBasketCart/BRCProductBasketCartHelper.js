({
    initList : function(component, event,helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let cartJson = sessionStorage.getItem('cart'+userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
            let basketList = JSON.parse(cartJson);
            let totalPrice = 0;
            //console.log(basketList);
            for (let obj in basketList){
                totalPrice += basketList[obj].price[0].UnitPrice;
            }
            component.set("v.productList", basketList);
            component.set("v.totalPrice", totalPrice);
            component.set("v.emptyCard", false);
           // console.log(basketList);
        } else {
            component.set("v.productList", "");
            component.set("v.emptyCard", true);
        }
    },
})