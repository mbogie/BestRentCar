({
    doInit: function(component, event, helper) {
        component.set("v.userProfile", $A.get("$Label.c.BRCCustomerCommunityProfile"));
        helper.initImages(component, event, helper);
        helper.initProfile(component, event, helper);
        helper.initFieldLabels(component, event, helper);
    },

    addImage : function(component, event, helper) {
       component.set("v.addImage", true);
    },

    closeModel : function(component, event, helper) {
       component.set("v.addImage", false);
       component.set("v.edit", false);
    },

    BRCReloadImagesAfterDelete : function(component, event, helper) {
       helper.initImages(component, event,helper);
    },

    handleUploadFinished : function(component, event, helper) {
                let recordId = component.get("v.recordId");
                let docId = event.getParam('files')[0].documentId;
                let type = component.get('v.imageType');
                let setType = component.get('c.setImageType');
                setType.setParams({
                    'documentId': docId,
                    'imageType': type,
                    'recordId' : recordId
                });
                setType.setCallback(this, function(response){
                    if (response.getState() === "SUCCESS") {
                  //  console.log(response.getReturnValue());
                    helper.initImages(component, event,helper);
                    component.set("v.addImage", false);
                    } else {
                        component.find("toastCmp").showToastModel(response.getError()[0].message, "error");
                    }
                });
          $A.enqueueAction(setType);
    },

    editRecord : function(component, event, helper) {
       component.set("v.edit", true);
    },

    saveRecord : function(component, event, helper) {
        component.find("productForm").submit();
    },

    handleChange: function (component, event) {
        let checkCmp = component.find("checkbox");
        if(checkCmp.get("v.value")) {
            component.set("v.imageType", "poster");
         } else {
            component.set("v.imageType", "image");
        }
    },
})