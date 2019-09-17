({
  init: function(component, event, helper) {
        let idsJson = sessionStorage.getItem('productSearch--recordIds');
        let searchText = sessionStorage.getItem('productSearch--searchText');
        if (!$A.util.isUndefinedOrNull(idsJson)) {
            let results = JSON.parse(idsJson);
            component.set('v.results', results);
            component.set('v.shownResults', results);
            sessionStorage.removeItem('productSearch--recordIds');
        }
        if (!$A.util.isUndefinedOrNull(searchText)) {
            let results = JSON.parse(idsJson);
            component.set('v.searchText', searchText);
            sessionStorage.removeItem('productSearch--searchText');
        }
        let action = component.get('c.getBrands');
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                console.log(response.getReturnValue());
                component.set("v.brands", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
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
        let doors = component.find('select').get('v.value');
        let brand = component.find('brandSelect').get('v.value');
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
                if (doors !== '' && doors !== null) {
                    if (x.product.Number_of_Doors__c != doors)
                        return false;
                }
                if (productionYear !== '' && productionYear !== null) {
                    if (x.product.Production_Year__c < productionYear)
                        return false;
                }
                if (brand !== '' && brand !== null) {
                    if (x.product.Brand__c !== brand)
                        return false;
                }
                return true;
            });
            component.set('v.shownResults', filterResults);
            console.log(filterResults);
  },
})