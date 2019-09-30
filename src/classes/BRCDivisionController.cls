public with sharing class BRCDivisionController {

    @AuraEnabled
    public static List <Account> getAccounts(String country, String city, String state) {
        try {
            return BRCAccountHelper.getAccounts(country, city, state);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, String> getObjectFieldsLabels(String objectName) {
        try {
        return BRCUtils.getObjectFieldsLabels(objectName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}