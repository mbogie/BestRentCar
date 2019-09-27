({
    initList: function(component, event, helper) {
        let recordId = component.get("v.recordId");
        let action = component.get("c.getAll");
        action.setParams({
            "productId": recordId
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let reviews = response.getReturnValue();
                component.set("v.reviews", reviews);
                let sum = 0;
                sum = reviews.reduce(function(sum, review) {
                    return sum + review.Rating__c;
                }, 0);
                let passReview = $A.get("e.c:BRCPassAverageReviewsEvent");
                passReview.setParams({
                    "count": reviews.length,
                    "sum": sum
                });
                passReview.fire();
            } else {
                component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
            }
        });
        $A.enqueueAction(action);
    },
})