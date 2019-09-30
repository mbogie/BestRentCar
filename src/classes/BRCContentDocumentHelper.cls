public with sharing class BRCContentDocumentHelper {

    public static final String TYPE_POSTER = BRCUtils.getValues('GalleryPoster');
    public static final String TYPE_IMAGE = BRCUtils.getValues('GalleryImage');

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

    public static List<String> getProductImages(String recordId) {
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
            if (version.Type__c == TYPE_POSTER) {
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
    }

    public static void deleteDocument(String documentId) {
        ContentDocument document = new ContentDocument(Id = documentId);
        delete document;
    }

    public static void setImageType(String documentId, String imageType, String recordId) {
        if (imageType == TYPE_POSTER) {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id, Type__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND Type__c LIKE :TYPE_POSTER];
            for (ContentVersion content : contentVersions) {
                content.Type__c = TYPE_IMAGE;
            }
            upsert contentVersions;
        }
        List<ContentVersion> contentVersions = [SELECT Id, Type__c FROM ContentVersion WHERE ContentDocumentId = :documentId];
        if (imageType == TYPE_IMAGE) {
            ContentDistribution cd = new ContentDistribution();
            cd.Name = TYPE_IMAGE;
            cd.ContentVersionId = contentVersions[0].Id;
            cd.PreferencesAllowViewInBrowser = true;
            cd.PreferencesLinkLatestVersion = true;
            cd.PreferencesNotifyOnVisit = false;
            cd.PreferencesPasswordRequired = false;
            cd.PreferencesAllowOriginalDownload = true;
            insert cd;
        }
        contentVersions[0].Type__c = imageType;
        upsert contentVersions[0];
    }

    public static BRCProductImagesController.ProductImages getProductDistributions(String productId) {
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :productId];
        Set<Id> contentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            contentIds.add(link.ContentDocumentId);
        }
        List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG', 'JPEG', 'PNG') ORDER BY SystemModstamp DESC];
        BRCProductImagesController.ProductImages pictures = new BRCProductImagesController.ProductImages();
        Set<Id> contentVersionImagesIds = new Set<Id>();
        Set<Id> contentVersionPosterIds = new Set<Id>();
        for (ContentVersion version : contentVersions) {
            if (version.Type__c == TYPE_POSTER) {
                contentVersionPosterIds.add(version.Id);
            } else {
                contentVersionImagesIds.add(version.Id);
            }
        }
        List<ContentDistribution> posterDistributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :contentVersionPosterIds];
        List<ContentDistribution> imageDistributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :contentVersionImagesIds];
        for (ContentDistribution cd : posterDistributions) {
            pictures.poster = cd;
        }
        pictures.images = imageDistributions;
        return pictures;
    }
}