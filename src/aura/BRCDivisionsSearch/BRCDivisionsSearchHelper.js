({
    handleErrors : function(errors) {
        let toastParams = {
            message: "Unknown error",
            type: "error"
        };
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

    handleSuccess : function(resultSize) {
        let toastParams = {
            message: $A.get("$Label.c.BRC_Division_Empty_List_Message"),
            type: "info"
        };
        if (resultSize > 0) {
            toastParams.type = "success";
            toastParams.message = "Found " + resultSize + " divisions.";
        }
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
})