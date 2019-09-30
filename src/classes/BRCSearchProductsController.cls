public with sharing class BRCSearchProductsController {

    public static String STANDARD_PRICEBOOK_ID = BRCUtils.getValues('StandardPricebookId');

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
                        break;
                    }
                }
            }
            for (PricebookEntry entry : standardPriceList) {
                for (SearchResultItem item : searchResults) {
                    if (entry.Product2Id == item.product.Id) {
                        item.price.add(entry);
                        break;
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
            return BRCContentDocumentHelper.getProductPoster(recordId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static List<String> getBrands() {
        try {
            return BRCProductHelper.getBrands();
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}