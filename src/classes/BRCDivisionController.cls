public with sharing class BRCDivisionController {

    @AuraEnabled
    public static List <Account> getAccounts(String country, String city, String state) {
        List<Account> resultList = new List<Account>();
        try {
            BRCQueryBuilder queryBuilder = new BRCQueryBuilder();
            queryBuilder.addResultField('Id').
                    addResultField('Name').
                    addResultField('BillingCity').
                    addResultField('BillingCountry').
                    addResultField('BillingAddress').
                    addResultField('BillingState').
                    addResultField('BillingPostalCode').
                    addResultField('BillingStreet').
                    addTableName('Account').
                    addSearchFieldStartsWithValue('BillingCountry', country).
                    addSearchFieldStartsWithValue('BillingState', state).
                    addSearchFieldStartsWithValue('BillingCity', city).
                    build();
            resultList = Database.query(queryBuilder.getQueryString());
        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return resultList;
    }

    @AuraEnabled
    public static Map<String,String> getObjectFieldsLabels(String objectName) {
        Map<String, String> accountFieldsLabels = new Map<String, String>();
        try {
            String type = objectName;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                accountFieldsLabels.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
            }
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return accountFieldsLabels;
    }
}