({
        handleErrors : function(component, errors) {
            component.find("toastCmp").showToastModel(errors.message, "error");
        },

        handleSuccess : function(component, resultSize) {
            if (resultSize > 0) {
               component.find("toastCmp").showToastModel("Found " + resultSize + " divisions.", "success");
            } else {
               component.find("toastCmp").showToastModel($A.get("$Label.c.BRC_Division_Empty_List_Message"),"info");
            }
        },
})