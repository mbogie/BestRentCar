({
    doInit: function(component, event, helper) {
        helper.initImages(component, event,helper);
        helper.initProfile(component, event,helper);
    },

    addImage : function(component, event, helper) {
       component.set("v.imageType", 'image');
       component.set("v.addImage", true);
    },

    addPoster : function(component, event, helper) {
       component.set("v.imageType", 'poster');
       component.set("v.addImage", true);
    },

    closeModel : function(component, event, helper) {
       component.set("v.addImage", false);
    },

    handleUploadFinished : function(component, event, helper) {
                console.log('added image in upload');
                let recordId = component.get("v.recordId");
                let docId = event.getParam('files')[0].documentId;
                let type = component.get('v.imageType');
                console.log('id of doc : ' + docId);
                let setType = component.get('c.setImageType');
                setType.setParams({
                    'documentId': docId,
                    'imageType': type,
                    'recordId' : recordId
                });
                setType.setCallback(this, function(response){
                    console.log(response.getState());
                    if (response.getState() === "SUCCESS") {
                    console.log(response.getReturnValue());
                    helper.initImages(component, event,helper);
                    component.set("v.addImage", false);
                }
                });
          $A.enqueueAction(setType);
    },
})