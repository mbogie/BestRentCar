global without sharing class BRCProductDetailController {

    global static String IMAGE_TYPE = BRCUtils.getValues('ImagePoster');

    global class ProductImages{
        @AuraEnabled global String poster;
        @AuraEnabled global List<ContentDistribution> images;
    }

    @AuraEnabled
    global static ProductImages getProductImages(String recordId) {
        List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
        Set<Id> contentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            contentIds.add(link.ContentDocumentId);
        }
        List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG','JPEG','PNG') ORDER BY SystemModstamp DESC];
        ProductImages pictures = new ProductImages();
        List<String> images = new List<String>();
        Set<Id> contentVersionIds = new Set<Id>();
        for (ContentVersion version : contentVersions) {
            if(version.Type__c == IMAGE_TYPE){
                List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = : version.Id];
                pictures.poster = distributions[0].ContentDownloadUrl;
            }
            contentVersionIds.add(version.Id);
        }
        List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId IN :contentVersionIds];
        pictures.images = distributions;
        return pictures;
    }

    @AuraEnabled
    global static Boolean setImageType(String documentId, String imageType, String recordId){
        if(imageType == IMAGE_TYPE) {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id, Type__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND Type__c LIKE :IMAGE_TYPE];
            if (!contentVersions.isEmpty()) delete new ContentDocument(Id = contentVersions[0].ContentDocumentId);
        }
        List<ContentVersion> versions = [SELECT Id, Type__c FROM ContentVersion WHERE ContentDocumentId = :documentId];
        if (versions.isEmpty()) {
            return false;
        } else {
            List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = : documentId];
            ContentDistribution cd = new ContentDistribution();
            cd.Name = 'img';
            cd.ContentVersionId = contentVersions[0].Id;
            cd.PreferencesAllowViewInBrowser= true;
            cd.PreferencesLinkLatestVersion=true;
            cd.PreferencesNotifyOnVisit=false;
            cd.PreferencesPasswordRequired=false;
            cd.PreferencesAllowOriginalDownload= true;
            Database.SaveResult saveResult = Database.insert(cd);
            versions[0].Type__c = imageType;
            Database.UpsertResult result = Database.upsert(versions[0], true);
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

    @AuraEnabled
    global static Boolean deleteDocument(String documentId){
        ContentDocument doc = new ContentDocument(Id = documentId);
        Database.DeleteResult deleteResult = Database.delete(doc);
        if(deleteResult.isSuccess()) return true;
        else return false;
    }
}