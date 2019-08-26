({
      BRCPassDivisionsListEvent : function(component, event, helper) {
            let divisions = event.getParam("divisions");
            component.set("v.divisions", divisions);
      },
})