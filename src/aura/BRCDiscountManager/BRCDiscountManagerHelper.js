({
    doReload: function(component, event, helper) {
                component.set("v.openModal", false);
                component.set("v.searchedProduct",{});
                component.set("v.discountType", "Unit");
                component.set("v.priceDiscount", 0);
                component.set("v.pricebook", {});
                component.set("v.selectProductsOption", "All");
                component.set("v.reload", false);
                component.set("v.reload", true);
    },
})