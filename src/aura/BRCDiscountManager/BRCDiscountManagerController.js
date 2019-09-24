({
    doInit: function(component, event, helper) {
        helper.doReload(component, event, helper);
    },

    createPricebook: function(component, event, helper) {
        let pricebook = component.get("v.pricebook");
        let currentDate = new Date().toISOString().slice(0, 10);
        console.log(currentDate);
        console.log(pricebook.End_Date__c);
        console.log(currentDate > pricebook.End_Date__c);
        if(pricebook.End_Date__c == null || pricebook.Start_Date__c == null){
            component.find("toastCmp").showToastModel('All fields are required', "error");
        } else if(pricebook.End_Date__c < currentDate){
            component.find("toastCmp").showToastModel('End Date must be after today', "error");
        } else if (pricebook.Start_Date__c > pricebook.End_Date__c) {
            component.find("toastCmp").showToastModel('End Date must be after Start Day', "error");
        } else {
            pricebook.IsActive = true;
    	let action = component.get("c.upsertPb");
    	action.setParams({
            "pricebook": pricebook
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                component.set("v.pricebookId", response.getReturnValue());
                component.set("v.openModal",true);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
        }
    },

   closeModel: function(component, event, helper) {
        let pricebookId = component.get("v.pricebookId");
    	let action = component.get("c.deletePb");
    	action.setParams({
            "pricebookId": pricebookId
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                helper.doReload(component, event, helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
      $A.enqueueAction(action);
   },

   createPricebookEntityList: function(component, event, helper) {
        let selectedOption = component.get("v.selectProductsOption");
        console.log(selectedOption);
        let pricebookId = component.get("v.pricebookId");
        let product = component.get("v.searchedProduct");
        let discountType = component.get("v.discountType");
        let priceDiscount = component.get("v.priceDiscount");
        if(priceDiscount == null || priceDiscount == 0){
            component.find("toastCmp").showToastModel("Discount Value is Required", "error");
        } else if(selectedOption == 'Brand' && (product.Brand__c == null || product.Brand__c == '')){
            component.find("toastCmp").showToastModel("Brand is required", "error");
        } else if(selectedOption == 'Single' && (product.ProductCode == null || product.ProductCode =='')){
                component.find("toastCmp").showToastModel("Brand is required", "error");
        } else {
    	let action = component.get("c.addProducts");
    	action.setParams({
    	    "discountType": discountType,
    	    "selectedOption": selectedOption,
    	    "pricebookId": pricebookId,
            "product": product,
            "price": priceDiscount,
            });
        action.setCallback( this, function( response ) {
            if ( component.isValid() && response.getState() === "SUCCESS" ) {
                component.find("toastCmp").showToastModel("Pricebook was created", "success");
                let reload = $A.get("e.c:BRCReloadPricebookListEvent");
                reload.fire();
                helper.doReload(component, event, helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
      $A.enqueueAction(action);
      }
   },

    changeProductsType: function(component, event, helper) {
        let products = component.find("productSelect").get("v.value");
        component.set("v.selectProductsOption", products);
    },

    discountSelect: function(component, event, helper) {
        let discount = component.find("discountTypeSelect").get("v.value");
        component.set("v.discountType", discount);
        component.set("v.priceDiscount", 0);
    },
})