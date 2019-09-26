({
	doInit : function(component, event, helper) {
		helper.initList(component, event, helper);
	},

    onSave : function(component, event, helper) {
        	let recordId = component.get("v.recordId");
        	let review = component.get("v.review");
        	if(review.Name){
        	review.Product__c = recordId;
			let action = component.get("c.createReview");
        	action.setParams({
          	"review": review
        	});
    		action.setCallback(this, function(response) {
                let state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    helper.initList(component, event, helper);
                    component.set("v.review.Name", "");
                    component.set("v.review.Comment__c", "");
                    component.set("v.review.Rating__c", 0);
                    component.set("v.reload", false);
                    component.set("v.reload", true);
                }
                else {
                    component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
                }
        	});
    		$A.enqueueAction(action);
        } else {
            component.find("toastCmp").showToastModel($A.get("{!$Label.c.BRC_Required_Title}"), "error");
        }
	},
})