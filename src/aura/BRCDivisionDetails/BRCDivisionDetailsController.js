({
      BRCPassDivisionDetail : function(component, event, helper) {
            let division = event.getParam("division");
            component.set("v.division", division);
            component.set("v.isSelected", true);
          },

        BRCClearDivisionDetails : function(component, event, helper) {
            let division = event.getParam("division");
            component.set("v.division", division);
            component.set("v.isSelected", false);
        },
})