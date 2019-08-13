({
           BRCGetDivisionDetailEvent : function(component, event, helper) {
            var division = event.getParam("division");
            component.set("v.division", division);
            component.set("v.isSelected", true);
          },
              editRecord : function(component, event, helper) {
              helper.showHide(component);
          	},
              handleSuccess : function(component, event, helper) {
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                  "title": "Success!",
                  "message": "The property's info has been updated.",
                  "type": "success"
              });
              toastEvent.fire();
              helper.showHide(component);
                  var recUpdate = $A.get("e.c:recordUpdated");
          	recUpdate.fire();
          },
          	handleCancel : function(component, event, helper) {
              helper.showHide(component);
              event.preventDefault();
          },
        BRCClearDivisionDetails : function(component, event, helper) {
            var division = event.getParam("division");
            component.set("v.division", division);
            component.set("v.isSelected", false);
        },
})