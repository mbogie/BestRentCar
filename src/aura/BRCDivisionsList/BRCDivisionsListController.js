({
      handleBRCGetDivisionsListEvent : function(component, event, helper) {
            var divisions = event.getParam("divisions");
            component.set("v.divisions", divisions);
      },
})