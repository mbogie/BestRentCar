public with sharing class BRCDiscountController {

    public final static String STANDARD_PRICEBOOK_ID = BRCUtils.getValues('StandardPricebookId');
    public final static List<String> ADD_PRODUCTS_OPTIONS = BRCUtils.getValues('AddProductsOptions').split(',');
    public final static List<String> DISCOUNT_TYPES = BRCUtils.getValues('DiscountType').split(',');

    @AuraEnabled
    public static List<Pricebook2> getAllPricebooks() {
        try {
            List<Pricebook2> pricebookList = new List<Pricebook2>();
            pricebookList = [SELECT Id,Name,Start_Date__c,End_Date__c,IsActive, Discount_Amount__c, Discount_Type__c FROM Pricebook2 WHERE IsStandard = false ORDER BY End_Date__c DESC];
            return pricebookList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static String upsertPb(Pricebook2 pricebook) {
        Pricebook2 newPricebook = (Pricebook2) pricebook;
        Database.UpsertResult result = Database.upsert(newPricebook);
        if (result.isSuccess()) return result.getId(); else throw new AuraHandledException(System.Label.BRC_Server_Error);
    }

    @AuraEnabled
    public static void upsertEntry(PricebookEntry pricebookEntry) {
        try {
            upsert pricebookEntry;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void deleteEntry(String entryId) {
        try {
            PricebookEntry entry = new PricebookEntry(Id = entryId);
            delete entry;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void deletePb(String pricebookId) {
        try {
            Pricebook2 pricebook = new Pricebook2(Id = pricebookId);
            delete pricebook;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static List<PricebookEntry> getPricebookEntries(String pricebookId) {
        try {
            List<PricebookEntry> entryList = new List<PricebookEntry>();
            entryList = [SELECT Name, Pricebook2Id, Product2.Name, Product2Id, Standard_Price__c, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId ORDER BY Product2.Name];
            return entryList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void addProducts(String discountType, String selectedOption, String pricebookId, Product2 product, Decimal price) {
        List<PricebookEntry> newEntriesList = new List<PricebookEntry>();
        Map<Id, Product2> productsList = new Map<Id, Product2>();
        if (selectedOption == ADD_PRODUCTS_OPTIONS.get(0)) {
            productsList = new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2]);
        } else if (selectedOption == ADD_PRODUCTS_OPTIONS.get(1)) {
            productsList = (String.isBlank(product.Model__c)) ? new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2 WHERE Brand__c LIKE :product.Brand__c]) :
                    new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2 WHERE Brand__c LIKE :product.Brand__c AND Model__c LIKE :product.Model__c]);
            if (productsList.isEmpty()) throw new AuraHandledException(System.Label.BRC_No_Products_To_Add);
        } else if (selectedOption == ADD_PRODUCTS_OPTIONS.get(2)) {
            productsList = new Map<Id, Product2>([SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode = :product.ProductCode]);
            if (productsList.isEmpty()) throw new AuraHandledException(System.Label.BRC_No_Products_To_Add);
        }

        List<PricebookEntry> oldEntriesList = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id = :pricebookId];
        if(!oldEntriesList.isEmpty()){
            Boolean inList = false;
            for(PricebookEntry oldEntry : oldEntriesList){
                if(productsList.containsKey(oldEntry.Product2Id)){
                    productsList.remove(oldEntry.Product2Id);
                }
            }
        }
        List<PricebookEntry> standardPriceList = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :STANDARD_PRICEBOOK_ID AND Product2Id in :productsList.keySet()];
        for (Id productId : productsList.keySet()) {
            for (PricebookEntry entry : standardPriceList) {
                if (entry.Product2Id == productId) {
                    newEntriesList.add(new PricebookEntry(Product2Id = productId, IsActive = true, Pricebook2Id = pricebookId, Standard_Price__c = entry.UnitPrice, UnitPrice = getDiscountPrice(entry.UnitPrice, price, discountType)));
                    break;
                }
            }
        }
        if(newEntriesList.isEmpty()) throw new AuraHandledException(System.Label.BRC_No_Products_To_Add);
        try {
            upsert newEntriesList;
            upsert new Pricebook2(Id = pricebookId, Discount_Type__c = discountType, Discount_Amount__c = price);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    public static Double getDiscountPrice(Decimal oldPrice, Decimal price, String discountType) {
        if (discountType == DISCOUNT_TYPES.get(1)) return oldPrice - oldPrice * price/100;
        else {
            Double newPrice = oldPrice - price;
            return (oldPrice - price < 1) ? 1 : newPrice;
        }
    }

    @AuraEnabled
    public static List<String> getSelectProductsOption(){
        return ADD_PRODUCTS_OPTIONS;
    }

    @AuraEnabled
    public static List<String> getDiscountTypes(){
        return DISCOUNT_TYPES;
    }
}