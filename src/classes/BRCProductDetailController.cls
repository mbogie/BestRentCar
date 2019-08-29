global without sharing class BRCProductDetailController {

    @AuraEnabled
    global static List<String> getProductImages(String recordId) {
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
        System.debug(documentLinks);
        Set<Id> contentIds = new Set<Id>();

        for (ContentDocumentLink link : documentLinks) {
            contentIds.add(link.ContentDocumentId);
        }

        List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG','JPEG','PNG') ORDER BY SystemModstamp DESC];
        System.debug(contentVersions);
        List<String> pictures = new List<String>();

        Set<Id> contentVersionIds = new Set<Id>();
        for (ContentVersion version : contentVersions) {
            contentVersionIds.add(version.Id);
        }

        List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN :contentVersionIds];
        System.debug(distributions);

        for(ContentDistribution distribution : distributions) {
            pictures.add(distribution.ContentDownloadUrl);
        }
        return pictures;
    }

}