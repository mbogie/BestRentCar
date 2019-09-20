({
    handleSearch: function(component, event, helper) {
        let searchText = component.get("v.searchText");
        let action = component.get("c.searchForProducts");
        action.setParams({
            "searchText": searchText
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let products = response.getReturnValue();
                sessionStorage.setItem("productSearch--products", JSON.stringify(products));
                sessionStorage.setItem("productSearch--searchText", searchText);
                let navEvt = $A.get("e.force:navigateToURL");
                navEvt.setParams({
                    url: "/product-search-result"
                });
                navEvt.fire();
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})