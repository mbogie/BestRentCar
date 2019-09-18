({
    doInit : function(component, event,helper) {
        helper.initPrice(component, event,helper);
    },

    addToBasket: function(component, event, helper) {
        let days = component.get("v.daysNumber");
        if(days >0) {
        let recordItem = component.get("v.productItem");
        let priceList = component.get("v.priceList");
        let objectItem = {
            price: priceList[0],
            product: recordItem,
            days: days
        };
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let cartJson = sessionStorage.getItem('cart'+userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
         //   console.log('add to list');
            let basketList = JSON.parse(cartJson);
                let isIn = basketList.filter(function(x){
               return x.product.Id == recordItem.Id;
            });
            if(isIn.length === 0){
            basketList.push(objectItem);
           // console.log(basketList);
            sessionStorage.setItem('cart'+userId, JSON.stringify(basketList));
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Product_Added_to_Cart}"), "info");
            } else {
            component.find("toastCmp").showToastModel("Product Already in Cart", "error");
            }
        } else {
         //   console.log('new list2');
            let basketList = [objectItem];
          //  console.log(basketList);
            sessionStorage.setItem('cart'+userId, JSON.stringify(basketList));
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Product_Added_to_Cart}"), "info");
        }
        } else {
            component.find("toastCmp").showToastModel("Input Proper Days Number", "error");
            component.set("v.daysNumber",1);
        }
    },

    plusDay : function(component, event,helper) {
        let days = component.get("v.daysNumber");
        component.set("v.daysNumber", Number(days)+1);
    },

    minusDay : function(component, event,helper) {
        let days = component.get("v.daysNumber");
        component.set("v.daysNumber", Number(days)-1);
    },
})