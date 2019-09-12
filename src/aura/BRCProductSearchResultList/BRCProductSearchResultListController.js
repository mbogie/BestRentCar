({
  init: function(component, event, helper) {
    var idsJson = sessionStorage.getItem('productSearch--recordIds');
    if (!$A.util.isUndefinedOrNull(idsJson)) {
      var ids = JSON.parse(idsJson);
      component.set('v.recordIds', ids);
      sessionStorage.removeItem('productSearch--recordIds');
    }
  }
})