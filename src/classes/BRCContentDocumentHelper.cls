public with sharing class BRCContentDocumentHelper {

    public static final String TYPE_POSTER = BRCUtils.getValues('GalleryPoster');

    public static String getProductPoster(String recordId) {
            String posterUrl = '';
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG', 'JPEG', 'PNG') AND Type__c = :TYPE_POSTER];
            if (!contentVersions.isEmpty()) {
                List<ContentDistribution> distributions = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = :contentVersions.get(0).Id];
                posterUrl = distributions.get(0).ContentDownloadUrl;
            }
        return posterUrl;
    }
}