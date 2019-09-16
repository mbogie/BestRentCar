({
  init: function(component, event, helper) {
        let idsJson = sessionStorage.getItem('productSearch--recordIds');
        if (!$A.util.isUndefinedOrNull(idsJson)) {
            let results = JSON.parse(idsJson);
            console.log(results);
            component.set('v.results', results);
            component.set('v.shownResults', results);
            sessionStorage.removeItem('productSearch--recordIds');
        }
  },

  changeView: function(component, event, helper) {
        let listView = component.get("v.listView");
        listView = (listView === true) ? false : true ;
        component.set("v.listView", listView);
  },

  filterResult: function(component, event, helper) {
        let allResults = component.get("v.results");
        let minPrice = component.get("v.minPrice");
        let maxPrice = component.get("v.maxPrice");
        let productionYear = component.get("v.productionYear");
        console.log(productionYear);
        let filterResults = allResults.filter(x => {
                if (minPrice !== '' && minPrice !== null) {
                    console.log('price --> ' + x.price[0].UnitPrice);
                    if (x.price[0].UnitPrice < minPrice)
                        return false;
                }
                if (maxPrice !== '' && maxPrice !== null) {
                    if (x.price[0].UnitPrice > maxPrice)
                        return false;
                }
                if (productionYear !== '' && productionYear !== null) {
                    console.log('year --> ' + x.product.Production_Year__c);
                    if (x.product.Production_Year__c < productionYear)
                        return false;
                }
                return true;
            });
            component.set('v.shownResults', filterResults);
            console.log(filterResults);
  },

})