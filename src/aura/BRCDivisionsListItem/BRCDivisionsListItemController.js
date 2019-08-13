({
    selectRecord : function(component, event, helper) {
           var division = component.get("v.division");
           console.log(division);
           var appEvent = $A.get("e.c:BRCGetDivisionDetailEvent");
           appEvent.setParams({
                       "division" : division
                       });
           appEvent.fire();
     },

})