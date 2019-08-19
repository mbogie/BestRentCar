({
      BRCPassDivisionDetailEvent : function(component, event, helper) {
            let division = event.getParam("division");
            component.set("v.division", division);
            component.set("v.isSelected", true);
          },

        BRCClearDivisionDetailsEvent : function(component, event, helper) {
            let division = event.getParam("division");
            component.set("v.division", division);
            component.set("v.isSelected", false);
        },
})