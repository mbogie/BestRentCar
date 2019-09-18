({
    doInit: function(component, event, helper) {
        helper.initList(component, event,helper);
    },

    clearCart: function(component, event, helper) {
        let userId = component.get("v.userId");
        sessionStorage.removeItem('cart'+userId);
        component.set("v.productList", null);
        component.set("v.totalPrice", 0);
    },

    plusDay : function(component, event,helper) {
        let userId = component.get("v.userId");
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let productList = component.get("v.productList");
        let days = productList[index].days;
        productList[index].days = Number(days) + 1;
        sessionStorage.setItem('cart'+userId, JSON.stringify(productList));
        helper.initList(component, event,helper);
    },

    deleteItem : function(component, event,helper) {
        let userId = component.get("v.userId");
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let productList = component.get("v.productList");
        productList.splice(index, 1);
        sessionStorage.setItem('cart'+userId, JSON.stringify(productList));
        helper.initList(component, event,helper);
    },

    minusDay : function(component, event,helper) {
        let userId = component.get("v.userId");
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let productList = component.get("v.productList");
        let days = productList[index].days;
        productList[index].days = Number(days) - 1;
        sessionStorage.setItem('cart'+userId, JSON.stringify(productList));
        helper.initList(component, event,helper);
    },

    navigateToProduct : function(component, event,helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let productList = component.get("v.productList");
        let recordId = productList[index].product.Id;
        console.log(recordId);
        let prefixSite = $A.get("$Site.siteUrlPrefix");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": prefixSite + "/detail/" + recordId
            });
        urlEvent.fire();
    },
})