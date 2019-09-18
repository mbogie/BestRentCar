({
    plusDay : function(component, event,helper) {
        index = component.get("v.listIndex");
      //  console.log(index);
        let days = component.get("v.item.days");
        component.set("v.item.days", Number(days)+1);
    },

    minusDay : function(component, event,helper) {
      //  index = component.get("v.listIndex");
      //  console.log(index);
        let days = component.get("v.item.days");
        component.set("v.item.days", Number(days)-1);
    },
})