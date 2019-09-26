({
    doInit: function(component, event, helper) {
        helper.prepareValues(component, event, helper);
    },

    createPricebook: function(component, event, helper) {
        let pricebook = component.get("v.pricebook");
        let currentDate = new Date().toISOString().slice(0, 10);
        if (pricebook.End_Date__c == null || pricebook.Start_Date__c == null) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Field_Error}"), "error");
        } else if (pricebook.End_Date__c < currentDate) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_EndDate_Error}"), "error");
        } else if (pricebook.Start_Date__c > pricebook.End_Date__c) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_EndDate_Error}"), "error");
        } else {
            pricebook.IsActive = true;
            let action = component.get("c.upsertPb");
            action.setParams({
                "pricebook": pricebook
            });
            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
                    component.set("v.pricebookId", response.getReturnValue());
                    component.set("v.openModal", true);
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
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                helper.doReload(component, event, helper);
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },

    createPricebookEntityList: function(component, event, helper) {
        let selectedOption = component.get("v.selectProductsOption");
        let discountTypes = component.get("v.discountTypes");
        let selectProductsOptions = component.get("v.selectProductsOptions");
        let pricebookId = component.get("v.pricebookId");
        let product = component.get("v.searchedProduct");
        let discountType = component.get("v.discountType");
        let priceDiscount = component.get("v.priceDiscount");
        if (priceDiscount == null || priceDiscount == 0) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Field_Error}"), "error");
        } else if (selectedOption == selectProductsOptions[1] && (product.Brand__c == null || product.Brand__c == '')) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Brand}"), "error");
        } else if (selectedOption == selectProductsOptions[2] && (product.ProductCode == null || product.ProductCode == '')) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Field_Error}"), "error");
        } else if (discountType == discountTypes[1] && (priceDiscount <= 0 || priceDiscount >= 100)) {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Percent_Error}"), "error");
        } else {
            let action = component.get("c.addProducts");
            action.setParams({
                "discountType": discountType,
                "selectedOption": selectedOption,
                "pricebookId": pricebookId,
                "product": product,
                "price": priceDiscount,
            });
            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS") {
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