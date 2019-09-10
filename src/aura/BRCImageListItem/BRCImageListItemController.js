({
    onSelect: function (component, event, helper) {
        component.set("v.openModal", true);
    },

    closeModel : function(component, event, helper) {
       component.set("v.openModal", false);
    },

    deleteImage : function(component, event, helper) {
        let distribution = component.get("v.distribution");
        let docId = distribution.ContentDocumentId;
        console.log('docId --> ' + docId);
        let deleteAction = component.get('c.deleteDocument');
                deleteAction.setParams({
                    'documentId': docId
                });
                deleteAction.setCallback(this, function(response){
                    console.log(response.getState());
                    if (response.getState() === "SUCCESS") {
                    console.log(response.getReturnValue());
                    component.set("v.openModal", false);
                    let reloadImages = $A.get("e.c:BRCReloadImagesAfterDelete");
                    reloadImages.fire();
                }
                });
         $A.enqueueAction(deleteAction);
    },
})