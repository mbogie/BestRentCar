public without sharing class BRCProductDetailController {

    @AuraEnabled
    public static List<String> getProductImages(String recordId) {
        try {
            return BRCContentDocumentHelper.getProductImages(recordId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static Map<String, String> getObjectFieldsLabels(String objectName) {
        try {
            return BRCUtils.getObjectFieldsLabels(objectName);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static List<PricebookEntry> getPrice(String recordId) {
        try {
            return BRCPricebookHelper.getPrice(recordId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}