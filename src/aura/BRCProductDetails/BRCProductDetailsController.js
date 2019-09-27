({
    doInit: function(component, event, helper) {
        helper.initImages(component, event, helper);
        helper.initFieldLabels(component, event, helper);
    },

    BRCPassAverageReviewsEvent: function(component, event, handler) {
        let count = event.getParam("count");
        let sum = event.getParam("sum");
        let average = sum / count;
        console.log(sum + ' ' + count);
        component.set("v.count", count);
        if (sum > 0) {
            component.set("v.sum", average.toFixed(1));
        } else {
            component.set("v.sum", 0);
        }
    },
})