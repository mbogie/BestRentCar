global without sharing class BRCProductDetailController {

    global static String IMAGE_TYPE = BRCUtils.getValues('ImagePoster');

    global class ProductImages {
        @AuraEnabled global String poster;
        @AuraEnabled global List<ContentDistribution> images;
    }

    @AuraEnabled
    global static ProductImages getProductImages(String recordId) {
        try {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
            Set<Id> contentIds = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                contentIds.add(link.ContentDocumentId);
            }
            List<ContentVersion> contentVersions = [SELECT Id,Type__c FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND FileType IN ('JPG', 'JPEG', 'PNG') ORDER BY SystemModstamp DESC];
            ProductImages pictures = new ProductImages();
            List<String> images = new List<String>();
            Set<Id> contentVersionIds = new Set<Id>();
            for (ContentVersion version : contentVersions) {
                if (version.Type__c == IMAGE_TYPE) {
                    List<ContentDistribution> distributions = [SELECT Id, DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId = :version.Id];
                    pictures.poster = distributions[0].ContentDownloadUrl;
                }
                contentVersionIds.add(version.Id);
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
            if (imageType == IMAGE_TYPE) {
                List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (:recordId)];
                Set<Id> contentIds = new Set<Id>();
                for (ContentDocumentLink link : documentLinks) {
                    contentIds.add(link.ContentDocumentId);
                }
                List<ContentVersion> contentVersions = [SELECT Id, Type__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentIds AND Type__c LIKE :IMAGE_TYPE];
                if (!contentVersions.isEmpty()) delete new ContentDocument(Id = contentVersions[0].ContentDocumentId);
            }
            List<ContentVersion> versions = [SELECT Id, Type__c FROM ContentVersion WHERE ContentDocumentId = :documentId];
            List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :documentId];
            ContentDistribution cd = new ContentDistribution();
            cd.Name = 'img';
            cd.ContentVersionId = contentVersions[0].Id;
            cd.PreferencesAllowViewInBrowser = true;
            cd.PreferencesLinkLatestVersion = true;
            cd.PreferencesNotifyOnVisit = false;
            cd.PreferencesPasswordRequired = false;
            cd.PreferencesAllowOriginalDownload = true;
            insert cd;
            versions[0].Type__c = imageType;
            upsert versions[0];
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    global static String getUserProfile() {
        try {
            String userProfile = '';
            List<Profile> profiles = [SELECT Name FROM profile WHERE id = :UserInfo.getProfileId()];
            userProfile = profiles.get(0).Name;
            return userProfile;
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
}