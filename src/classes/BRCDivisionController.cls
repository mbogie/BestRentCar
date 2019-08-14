public with sharing class BRCDivisionController {

    @AuraEnabled
    public static List <Account> getAccounts(String country, String city, String state) {
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
        return Database.query(queryBuilder.getQueryString());
    }

    @AuraEnabled
    public static Map<String,String> getAccountFieldsLabels(String obj) {
        Map<String, String> accountFieldsLabels = new Map<String, String>();
        String type = obj;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            accountFieldsLabels.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
        }
        return accountFieldsLabels;
    }
}