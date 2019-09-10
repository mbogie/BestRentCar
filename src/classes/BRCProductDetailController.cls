global without sharing class BRCProductDetailController {

    global class ProductImages{
        @AuraEnabled global String poster;
        @AuraEnabled global List<String> images;
    }

    @AuraEnabled
    global static ProductImages getProductImages(String recordId) {
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
        System.debug(documentLinks);
        Set<Id> contentIds = new Set<Id>();

        for (ContentDocumentLink link : documentLinks) {
            contentIds.add(link.ContentDocumentId);
        }

        List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG','JPEG','PNG') ORDER BY SystemModstamp DESC];
        System.debug(contentVersions);
        ProductImages pictures = new ProductImages();
        List<String> images = new List<String>();

        Set<Id> contentVersionIds = new Set<Id>();
        for (ContentVersion version : contentVersions) {
            if(version.Type__c == 'poster'){
                List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = : version.Id];
                pictures.poster = distributions[0].ContentDownloadUrl;
            }
            contentVersionIds.add(version.Id);
        }

        List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :contentVersionIds];
        System.debug(distributions);

        for(ContentDistribution distribution : distributions) {
            images.add(distribution.ContentDownloadUrl);
        }
        pictures.images = images;
        return pictures;
    }

    @AuraEnabled
    global static Boolean setImageType(String documentId, String imageType, String recordId){
        System.debug(documentId + ', type ' + imageType + ', recordId' + recordId);
        if(imageType == 'poster') {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id, Type__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND Type__c LIKE 'poster'];
            if (!contentVersions.isEmpty()) delete new ContentDocument(Id = contentVersions[0].ContentDocumentId);
        }
        List<ContentVersion> versions = [SELECT Id, Type__c FROM ContentVersion WHERE ContentDocumentId = :documentId];
        if (versions.isEmpty()) {
            return false;
        } else {
            List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = : documentId];
            ContentDistribution cd = new ContentDistribution();
            cd.Name = 'Image';
            cd.ContentVersionId = contentVersions[0].Id;
            cd.PreferencesAllowViewInBrowser= true;
            cd.PreferencesLinkLatestVersion=true;
            cd.PreferencesNotifyOnVisit=false;
            cd.PreferencesPasswordRequired=false;
            cd.PreferencesAllowOriginalDownload= true;
            Database.SaveResult saveResult = Database.insert(cd);
            versions[0].Type__c = imageType;
            Database.UpsertResult result = Database.upsert(versions[0], true);
            System.debug('success');
            return result.isSuccess();
        }
    }

    @AuraEnabled
    global static String getUserProfile(){
        String userProfile = '';
        List<Profile> profiles = [SELECT Name FROM profile WHERE id = :UserInfo.getProfileId()];
        userProfile = profiles.get(0).Name;
        return userProfile;
    }
}