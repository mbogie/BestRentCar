public with sharing class BRCContentDocumentLinkHandler implements BRCITrigger{

    public BRCContentDocumentLinkHandler(){
    }
    public void bulkBefore(){
    }

    public void bulkAfter(){
    }

    public void beforeInsert(List<SObject> newlstObj){
        List<ContentDocumentLink> oldList = newlstObj;
        for ( ContentDocumentLink link : oldList){
            link.Visibility = 'AllUsers';
        }
    }

    public void beforeUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj){
    }

    public void beforeDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj){
    }

    public void afterInsert(List<SObject> newlstObj,Map<Id,SObject> newMapObj){
    }

    public void afterUpdate(List<SObject> newlstObj,List<SObject> oldlstObj,Map<Id,SObject> newMapObj, Map<Id,SObject> oldMapObj) {
    }

    public void afterDelete(List<SObject> oldlstObj,Map<Id,SObject> oldMapObj){
    }

    public void andFinally(){
    }
}