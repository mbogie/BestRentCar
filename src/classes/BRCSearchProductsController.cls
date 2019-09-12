public with sharing class BRCSearchProductsController {

    @AuraEnabled
    public static List<String> searchForIds(String searchText) {
        List<List<SObject>> results = [FIND :searchText IN ALL FIELDS  RETURNING Product2(Id)];
        List<String> ids = new List<String>();
        for (List<SObject> sobjs : results) {
            for (SObject sobj : sobjs) {
                ids.add(sobj.Id);
            }
        }
        return ids;
    }
    @AuraEnabled
    public static String getProductPoster(String recordId) {
        try {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG', 'JPEG', 'PNG') AND Type__c = 'poster'];
            List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId = :contentVersions.get(0).Id];
            return distributions.get(0).ContentDownloadUrl;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}