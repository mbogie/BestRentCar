({
    handleClick : function(component, event, helper) {
        helper.handleSearch(component, event, helper);
    },

    handleKeyUp : function(component, event, helper) {
        if(event.getParams().keyCode == 13){
            console.log('aaa');
            helper.handleSearch(component, event, helper);
        }
    },
})