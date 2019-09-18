({
    doInit: function(component, event, helper) {
        helper.initPoster(component, event,helper);
    },

    navigateToRecord: function(component, event, helper) {
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let recordId = component.get("v.resultItem").product.Id;
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
        "url": prefixSite + "/detail/" + recordId
        });
        urlEvent.fire();
    },

    addToBasket: function(component, event, helper) {
        let resultItem = component.get("v.resultItem");
      //  console.log(JSON.stringify(resultItem));
        let objectItem = {
            price: resultItem.price[0],
            product: resultItem.product,
            days: component.get("v.daysNumber")
        }
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let cartJson = sessionStorage.getItem('cart'+userId);
        if (!$A.util.isUndefinedOrNull(cartJson)) {
            let basketList = JSON.parse(cartJson);
            let isIn = basketList.filter(function(x){
               return x.product.Id == resultItem.product.Id;
            });
            if(isIn.length === 0){
           // console.log('tak ' + isIn.length);
            basketList.push(objectItem);
         //   console.log(basketList);
            sessionStorage.setItem('cart'+userId, JSON.stringify(basketList));
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Product_Added_to_Cart}"), "info");
            } else {
           //     console.log('nie ' + isIn.length);
            component.find("toastCmp").showToastModel("Product Already in Cart", "error");
            }
        } else {
         //   console.log('new list');
            let basketList = [objectItem];
         //   console.log(basketList);
            sessionStorage.setItem('cart'+userId, JSON.stringify(basketList));
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Product_Added_to_Cart}"), "info");
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

/*    changeDays : function(component, event, helper) {
        let days = component.find("inputDays").get("v.daysNumber");
        console.log(days);
    },*/
})