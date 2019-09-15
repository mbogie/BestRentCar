global without sharing class BRCProductDetailController {

    global static String IMAGE_TYPE = BRCUtils.getValues('GalleryPoster');

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
            Set<Id> contentVersionIds = new Set<Id>();
            for (ContentVersion version : contentVersions) {
                if (version.Type__c == IMAGE_TYPE) {
                    List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = :version.Id];
                    if(!distributions.isEmpty()) pictures.add(distributions[0].ContentDownloadUrl);
                } else {
                    contentVersionIds.add(version.Id);
                }
            }
            List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :contentVersionIds];
            for(ContentDistribution cd : distributions){
                pictures.add(cd.ContentDownloadUrl);
            }
            return pictures;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    global static Map<String,String> getObjectFieldsLabels(String objectName) {
        Map<String, String> fieldsLabels = new Map<String, String>();
        try {
            String type = objectName;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                fieldsLabels.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
            }
        }catch (Exception e){
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
        return fieldsLabels;
    }

    @AuraEnabled
    global static List<PricebookEntry> getPrice(String recordId) {
        try {
            List<PricebookEntry> priceList = new List<PricebookEntry>();
            priceList = [SELECT Id, Pricebook2Id, UnitPrice, IsActive FROM PricebookEntry WHERE Product2Id = :recordId];
            return priceList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}