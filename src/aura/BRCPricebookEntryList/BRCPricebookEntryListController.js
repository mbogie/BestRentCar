({
   BRCPassPricebookEvent: function(component, event, helper) {
       helper.initEntryList(component, event,helper);
       component.set("v.selectedIndex", -1);
       component.set("v.blockButtons", false);
   },

    deleteItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
    	let action = component.get("c.deleteEntry");
    	action.setParams({
            "entryId": entryList[index].Id
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                helper.reloadEntryList(component, event,helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    editItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        component.set("v.selectedIndex", Number(index));
        component.set("v.blockButtons", true);
    },

    undoItem: function(component, event, helper) {
        helper.resetAttributes(component, event,helper);
    },

    saveItem: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
        let entry = entryList[index];
        if(entry.UnitPrice == null || entry.UnitPrice >= entry.Standard_Price__c || entry.UnitPrice <= 1){
            component.find("toastCmp").showToastModel('Discount Price must be less then standard price and higher than 0', "error");
        } else {
    	let action = component.get("c.upsertEntry");
    	action.setParams({
            "pricebookEntry": entry
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                helper.resetAttributes(component, event,helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
        }
    },

    addProductsToPricebook: function(component, event, helper) {
        helper.resetAttributes(component, event,helper);
        component.set("v.openModal",true);
    },

   addPricebookEntityList: function(component, event, helper) {
        let selectedOption = component.get("v.selectProductsOption");
        let pricebook = component.get("v.pricebook");
        let product = component.get("v.searchedProduct");
        if(selectedOption == 'Brand' && (product.Brand__c == null || product.Brand__c == '')){
            component.find("toastCmp").showToastModel("Brand is required", "error");
        } else if(selectedOption == 'Single' && (product.ProductCode == null || product.ProductCode =='')){
                component.find("toastCmp").showToastModel("ProductCode is required", "error");
        } else {
    	let action = component.get("c.addProducts");
    	action.setParams({
    	    "discountType": pricebook.Discount_Type__c,
    	    "selectedOption": selectedOption,
    	    "pricebookId": pricebook.Id,
            "product": product,
            "price": pricebook.Discount_Amount__c,
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                component.find("toastCmp").showToastModel("Products was added", "success");
                helper.resetAttributes(component, event,helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
      $A.enqueueAction(action);
      }
   },

    closeModel: function(component, event, helper) {
        helper.resetAttributes(component, event,helper);
    },

    changeProductsType: function(component, event, helper) {
        let products = component.find("productSelect").get("v.value");
        component.set("v.selectProductsOption", products);
    },

    navigateToRecord: function(component, event, helper) {
        let selectedItem = event.currentTarget;
        let index = selectedItem.dataset.index;
        let entryList = component.get("v.pricebookEntryList");
        let entry = entryList[index];
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": entry.Product2Id
        });
        navEvt.fire();
    },

})