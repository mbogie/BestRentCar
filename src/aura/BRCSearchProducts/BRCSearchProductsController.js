({
    handleClick: function(component, event, helper) {
        helper.handleSearch(component, event, helper);
    },

    handleKeyUp: function(component, event, helper) {
        if(event.getParams().keyCode == 13){
            helper.handleSearch(component, event, helper);
        }
    },

    showBasket: function(component, event, helper) {
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(userId);
        let cartJson = sessionStorage.getItem('cart'+userId);
        console.log(JSON.parse(cartJson));

    },

    onButtonClick: function(component, event, helper) {
        component.find("showme").slideDown();
    },

    showCard: function(component, event, helper) {
        window.isoverdiv = true;
    },


})