global without sharing class BRCProductDetailController {

    global static String IMAGE_TYPE = BRCUtils.getValues('GalleryPoster');
    global static String STANDARD_PRICEBOOK_ID = '01s2p000001DmINAA0';

    @AuraEnabled
    global static List<String> getProductImages(String recordId) {
        try {
            List<String> pictures = new List<String>();
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG', 'JPEG', 'PNG') ORDER BY SystemModstamp DESC];
            Set<Id> contentVersionImagesIds = new Set<Id>();
            Set<Id> contentVersionPosterIds = new Set<Id>();
            for (ContentVersion version : contentVersions) {
                if (version.Type__c == IMAGE_TYPE) {
                    contentVersionPosterIds.add(version.Id);
                } else {
                    contentVersionImagesIds.add(version.Id);
                }
            }
            List<ContentDistribution> posterDistributions = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :contentVersionPosterIds];
            List<ContentDistribution> imageDistributions = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :contentVersionImagesIds];
            for (ContentDistribution cd : posterDistributions) {
                pictures.add(cd.ContentDownloadUrl);
            }
            for (ContentDistribution cd : imageDistributions) {
                pictures.add(cd.ContentDownloadUrl);
            }
            return pictures;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    global static Map<String, String> getObjectFieldsLabels(String objectName) {
        Map<String, String> fieldsLabels = new Map<String, String>();
        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(objectName);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                fieldsLabels.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
        return fieldsLabels;
    }

    @AuraEnabled
    global static List<PricebookEntry> getPrice(String recordId) {
        try {
            Map<Id, Pricebook2> pricebookList = new Map<Id, Pricebook2>([SELECT Id, IsActive, Start_Date__c, End_Date__c FROM Pricebook2 WHERE IsActive = true AND Start_Date__c <= :date.today() AND End_Date__c >= :date.today()]);
            List<PricebookEntry> priceList = new List<PricebookEntry>();
            priceList = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice, Standard_Price__c, IsActive FROM PricebookEntry WHERE Product2Id = :recordId AND Pricebook2Id IN :pricebookList.keySet() ORDER BY UnitPrice ASC];
            return (!priceList.isEmpty())? priceList : [SELECT Id, Pricebook2Id, Standard_Price__c, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :recordId AND Pricebook2Id = :STANDARD_PRICEBOOK_ID];
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}