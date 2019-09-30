public with sharing class BRCDiscountController {

    public final static String STANDARD_PRICEBOOK_ID = BRCUtils.getValues('StandardPricebookId');
    public final static List<String> ADD_PRODUCTS_OPTIONS = BRCUtils.getValues('AddProductsOptions').split(',');
    public final static List<String> DISCOUNT_TYPES = BRCUtils.getValues('DiscountType').split(',');

    @AuraEnabled
    public static List<Pricebook2> getAllPricebooks() {
        try {
            return BRCPricebookHelper.getAllPricebooks();
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static String upsertPb(Pricebook2 pricebook) {
        String pricebookId = BRCPricebookHelper.upsertPricebook(pricebook);
        if (String.isNotBlank(pricebookId)) return pricebookId; else throw new AuraHandledException(System.Label.BRC_Server_Error);
    }

    @AuraEnabled
    public static void upsertEntry(PricebookEntry pricebookEntry) {
        try {
            BRCPricebookHelper.upsertPricebookEntry(pricebookEntry);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void deleteEntry(String entryId) {
        try {
            BRCPricebookHelper.deletePricebookEntry(entryId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void deletePb(String pricebookId) {
        try {
            BRCPricebookHelper.deletePricebook(pricebookId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static List<PricebookEntry> getPricebookEntries(String pricebookId) {
        try {
            return BRCPricebookHelper.getAllPricebookEntries(pricebookId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static void addProducts(String discountType, String selectedOption, String pricebookId, Product2 product, Decimal price) {
        List<PricebookEntry> newEntriesList = new List<PricebookEntry>();
        Map<Id, Product2> productsList = BRCPricebookHelper.getProductsToAddList(selectedOption,product);
        if (productsList.isEmpty()) throw new AuraHandledException(System.Label.BRC_No_Products_To_Add);

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