public with sharing class BRCSearchProductsController {

    public static final String TYPE_POSTER = BRCUtils.getValues('GalleryPoster');
    public static String STANDARD_PRICEBOOK_ID = '01s2p000001DmINAA0';

    public class SearchResultItem {
        @AuraEnabled public Product2 product = new Product2();
        @AuraEnabled public List<PricebookEntry> price = new List<PricebookEntry>();
    }

    @AuraEnabled
    public static List<SearchResultItem> searchForProducts(String searchText) {
        try {
            List<List<SObject>> results = [FIND :searchText IN ALL FIELDS RETURNING Product2(Id, Name, Brand__c, Production_Year__c, Engine__c, Number_of_Doors__c WHERE IsActive = true)];
            List<BRCSearchProductsController.SearchResultItem> searchResults = new List<BRCSearchProductsController.SearchResultItem>();
            List<String> ids = new List<String>();
            for (List<SObject> sobjs : results) {
                for (SObject sobj : sobjs) {
                    ids.add(sobj.Id);
                    SearchResultItem item = new SearchResultItem();
                    item.product = (Product2) sobj;
                    searchResults.add(item);
                }
            }
            List<PricebookEntry> standardPriceList = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice, Standard_Price__c, IsActive FROM PricebookEntry WHERE Product2Id IN :ids AND Pricebook2Id = :STANDARD_PRICEBOOK_ID];
            Map<Id, Pricebook2> pricebookList = new Map<Id, Pricebook2>([SELECT Id, IsActive, Start_Date__c, End_Date__c FROM Pricebook2 WHERE IsActive = true AND Start_Date__c <= :date.today() AND End_Date__c >= :date.today()]);
            List<PricebookEntry> priceList = new List<PricebookEntry>();
            priceList = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice, Standard_Price__c, IsActive FROM PricebookEntry WHERE Product2Id IN :ids AND Pricebook2Id IN :pricebookList.keySet() ORDER BY UnitPrice ASC];
            for (PricebookEntry entry : priceList) {
                for (SearchResultItem item : searchResults) {
                    if (entry.Product2Id == item.product.Id) {
                        item.price.add(entry);
                    }
                }
            }
            for (PricebookEntry entry : standardPriceList) {
                for (SearchResultItem item : searchResults) {
                    if (entry.Product2Id == item.product.Id) {
                        item.price.add(entry);
                    }
                }
            }
            return searchResults;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static String getProductPoster(String recordId) {
        try {
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
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static List<String> getBrands() {
        try {
            List<String> pickListValuesList = new List<String>();
            Schema.DescribeFieldResult fieldResult = Product2.Brand__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry pickListVal : ple) {
                pickListValuesList.add(pickListVal.getLabel());
            }
            return pickListValuesList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}