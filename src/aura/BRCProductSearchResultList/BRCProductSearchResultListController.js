({
    doInit: function(component, event, helper) {
        let productsJson = sessionStorage.getItem("productSearch--products");
        let searchText = sessionStorage.getItem("productSearch--searchText");
        if (!$A.util.isUndefinedOrNull(productsJson)) {
            let results = JSON.parse(productsJson);
            component.set("v.results", results);
            component.set("v.shownResults", results);
        }
        if (!$A.util.isUndefinedOrNull(searchText)) {
            component.set("v.searchText", searchText);
        }
        helper.initBrands(component, event, helper);
    },

    changeView: function(component, event, helper) {
        let listView = component.get("v.listView");
        listView = (listView === true) ? false : true;
        component.set("v.listView", listView);
    },

    filterResult: function(component, event, helper) {
        let allResults = component.get("v.results");
        let minPrice = component.get("v.minPrice");
        let maxPrice = component.get("v.maxPrice");
        let productionYear = component.get("v.productionYear");
        let doors = component.get("v.numberOfDoors");
        let brand = component.find("brandSelect").get("v.value");
        let filterResults = allResults.filter(x => {
            if (minPrice !== "" && minPrice !== null) {
                if (x.price[0].UnitPrice < minPrice)
                    return false;
            }
            if (maxPrice !== "" && maxPrice !== null) {
                if (x.price[0].UnitPrice > maxPrice)
                    return false;
            }
            if (doors !== "" && doors !== null) {
                if (x.product.Number_of_Doors__c != doors)
                    return false;
            }
            if (productionYear !== "" && productionYear !== null) {
                if (x.product.Production_Year__c < productionYear)
                    return false;
            }
            if (brand !== "" && brand !== null) {
                if (x.product.Brand__c !== brand)
                    return false;
            }
            return true;
        });
        component.set("v.shownResults", filterResults);
    },
})