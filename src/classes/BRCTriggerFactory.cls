public with sharing class BRCTriggerFactory {

    public static void createHandler(Schema.sObjectType soType) {
        BRCITrigger handler = getHandler(soType);
        if (handler != null) execute(handler);
    }

    private static void execute(BRCITrigger handler) {
        if (Trigger.isBefore) {
            handler.bulkBefore();
            if (Trigger.isDelete) {
                handler.beforeDelete(trigger.old,trigger.oldMap);
            } else if (Trigger.isInsert) {
                handler.beforeInsert(trigger.new);
            } else if (Trigger.isUpdate) {
                handler.beforeUpdate(trigger.new,trigger.old,trigger.newMap,trigger.oldMap);
            }
        } else {
            handler.bulkAfter();
            if (Trigger.isDelete) {
                handler.afterDelete(trigger.old,trigger.oldMap);
            } else if (Trigger.isInsert) {
                handler.afterInsert(trigger.new,trigger.newMap);
            } else if (Trigger.isUpdate) {
                handler.afterUpdate(trigger.new,trigger.old,trigger.newMap,trigger.oldMap);
            }
        }
        handler.andFinally();
    }

    private static BRCITrigger getHandler(Schema.sObjectType soType) {
        if (soType == ContentDocumentLink.sObjectType) {
            return new BRCContentDocumentLinkHandler();
        } return null;
    }
}