public with sharing class BRCProductRatingController {

    @AuraEnabled
    public static List<Review__c> getAll(Id productId) {
        try {
            return [SELECT Id,Name,Comment__c,Rating__c,LastModifiedDate,CreatedDate,CreatedBy.Name,CreatedBy.SmallPhotoUrl,CreatedBy.CompanyName,Title__c, Product__c FROM Review__c WHERE Product__c = :productId ORDER BY CreatedDate DESC];
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void createReview(Review__c review) {
        try {
            upsert review;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}