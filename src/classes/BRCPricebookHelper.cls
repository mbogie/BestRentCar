public with sharing class BRCPricebookHelper {

    public static String STANDARD_PRICEBOOK_ID = BRCUtils.getValues('StandardPricebookId');

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
}