public with sharing class BRCProductImagesController {

    public class ProductImages {
        @AuraEnabled public ContentDistribution poster;
        @AuraEnabled public List<ContentDistribution> images;
    }

    @AuraEnabled
    public static ProductImages getProductImages(String recordId) {
        try {
            return BRCContentDocumentHelper.getProductDistributions(recordId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void setImageType(String documentId, String imageType, String recordId) {
        try {
            BRCContentDocumentHelper.setImageType(documentId, imageType, recordId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void deleteDocument(String documentId) {
        try {
            BRCContentDocumentHelper.deleteDocument(documentId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}