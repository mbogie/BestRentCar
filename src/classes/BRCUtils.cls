public with sharing class BRCUtils {

    public static String getValues(String brcName) {
        BRC_Settings__c brcItem = BRC_Settings__c.getInstance(brcName);
        if (brcItem == null) {
            return '';
        } else {
            return brcItem.Value__c;
        }
    }

    public static Map<String, String> getObjectFieldsLabels(String objectName) {
        Map<String, String> accountFieldsLabels = new Map<String, String>();
        String type = objectName;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName : fieldMap.keySet()) {
            accountFieldsLabels.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
        }
        return accountFieldsLabels;
    }

    public static User getUserAddress() {
        return [SELECT Id, Address FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }

    public static List<String> getOrdersStatusList() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Order.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    public static List<String> getContractStatusList() {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Contract.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
}