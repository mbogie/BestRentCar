({
    handleSearch : function(component, event, helper) {
      let searchText = component.get('v.searchText');
      let action = component.get('c.searchForIds');
      action.setParams({
          searchText: searchText
          });
      action.setCallback(this, function(response) {
        let state = response.getState();
        if (state === 'SUCCESS') {
          let ids = response.getReturnValue();
          sessionStorage.setItem('productSearch--recordIds', JSON.stringify(ids));
          sessionStorage.setItem('productSearch--searchText', searchText);
          let navEvt = $A.get('e.force:navigateToURL');
          navEvt.setParams({url: '/product-search-result'});
          navEvt.fire();
        }
      });
      $A.enqueueAction(action);
    },
})