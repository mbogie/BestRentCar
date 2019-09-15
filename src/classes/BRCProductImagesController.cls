global with sharing class BRCProductImagesController {

    global static String POSTER_TYPE = BRCUtils.getValues('GalleryPoster');
    global static String IMAGE_TYPE = BRCUtils.getValues('GalleryImage');

    global class ProductImages {
        @AuraEnabled global ContentDistribution poster;
        @AuraEnabled global List<ContentDistribution> images;
    }

    @AuraEnabled
    global static ProductImages getProductImages(String recordId) {
        try {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG', 'JPEG', 'PNG') ORDER BY SystemModstamp DESC];
            ProductImages pictures = new ProductImages();
            List<String> images = new List<String>();
            Set<Id> contentVersionIds = new Set<Id>();
            for (ContentVersion version : contentVersions) {
                if (version.Type__c == POSTER_TYPE) {
                    List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId = :version.Id];
                    pictures.poster = distributions[0];
                } else {
                    contentVersionIds.add(version.Id);
                }
            }
            List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :contentVersionIds];
            pictures.images = distributions;
            return pictures;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    global static void setImageType(String documentId, String imageType, String recordId) {
        try {
            if (imageType == POSTER_TYPE) {
                List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
                Set<Id> contentIds = new Set<Id>();
                for (ContentDocumentLink link : documentLinks) {
                    contentIds.add(link.ContentDocumentId);
                }
                List<ContentVersion> contentVersions = [SELECT Id, Type__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND Type__c LIKE :POSTER_TYPE];
                if (!contentVersions.isEmpty()) {
                    for(ContentVersion content : contentVersions){
                        content.Type__c = IMAGE_TYPE;
                    }
                    upsert contentVersions;
                }
            }
            List<ContentVersion> contentVersions = [SELECT Id, Type__c FROM ContentVersion WHERE ContentDocumentId = :documentId];
            if(imageType == IMAGE_TYPE) {
                ContentDistribution cd = new ContentDistribution();
                cd.Name = IMAGE_TYPE;
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
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    global static void deleteDocument(String documentId) {
        try {
            ContentDocument doc = new ContentDocument(Id = documentId);
            delete doc;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}