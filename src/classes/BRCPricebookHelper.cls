public with sharing class BRCPricebookHelper {

    public static String STANDARD_PRICEBOOK_ID = BRCUtils.getValues('StandardPricebookId');
    public final static List<String> ADD_PRODUCTS_OPTIONS = BRCUtils.getValues('AddProductsOptions').split(',');

    public static List<PricebookEntry> getPrice(String recordId) {
        Map<Id, Pricebook2> pricebookList = new Map<Id, Pricebook2>([SELECT Id, IsActive, Start_Date__c, End_Date__c FROM Pricebook2 WHERE IsActive = true AND Start_Date__c <= :date.today() AND End_Date__c >= :date.today()]);
        List<PricebookEntry> priceList = new List<PricebookEntry>();
        priceList = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice, Standard_Price__c, IsActive FROM PricebookEntry WHERE Product2Id = :recordId AND Pricebook2Id IN :pricebookList.keySet() ORDER BY UnitPrice ASC];
        return (!priceList.isEmpty()) ? priceList : [SELECT Id, Pricebook2Id, Standard_Price__c, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :recordId AND Pricebook2Id = :STANDARD_PRICEBOOK_ID];
    }

    public static Id getPricebookEntry(Id productId) {
        List<PricebookEntry> entries = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :STANDARD_PRICEBOOK_ID];
        return entries.get(0).Id;
    }

    public static List<Pricebook2> getAllPricebooks() {
        return [SELECT Id, Name, Start_Date__c, End_Date__c, IsActive, Discount_Amount__c, Discount_Type__c FROM Pricebook2 WHERE IsStandard = false ORDER BY End_Date__c DESC];
    }

    public static List<PricebookEntry> getAllPricebookEntries(String pricebookId) {
        return [SELECT Name, Pricebook2Id, Product2.Name, Product2Id, Standard_Price__c, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId ORDER BY Product2.Name];
    }

    public static String upsertPricebook(Pricebook2 pricebook) {
        Pricebook2 newPricebook = (Pricebook2) pricebook;
        Database.UpsertResult result = Database.upsert(newPricebook);
        return (result.isSuccess()) ? result.getId() : '';
    }

    public static void upsertPricebookEntry(PricebookEntry pricebookEntry) {
        upsert pricebookEntry;
    }

    public static void deletePricebook(String pricebookId) {
        delete new Pricebook2(Id = pricebookId);
    }

    public static void deletePricebookEntry(String entryId) {
        delete new PricebookEntry(Id = entryId);
    }

    public static Map<Id, Product2> getProductsToAddList(String selectedOption, Product2 product) {
        if (selectedOption == ADD_PRODUCTS_OPTIONS.get(0)) {
            return new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2]);
        } else if (selectedOption == ADD_PRODUCTS_OPTIONS.get(1)) {
            return (String.isBlank(product.Model__c)) ? new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2 WHERE Brand__c LIKE :product.Brand__c]) :
                    new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2 WHERE Brand__c LIKE :product.Brand__c AND Model__c LIKE :product.Model__c]);
        } else if (selectedOption == ADD_PRODUCTS_OPTIONS.get(2)) {
            return new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode = :product.ProductCode]);
        } else return new Map<Id,Product2>();
    }
}