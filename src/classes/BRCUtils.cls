public with sharing class BRCUtils {

    public static String getCredentialsValues(String csName) {
        Cs_Settings__c csItem = Cs_Settings__c.getInstance(csName);
        if (csItem == null) {
            return '';
        } else {
            return csItem.Value__c;
        }
    }

    public static String getValues(String csName) {
        BRC_Settings__c brcItem = BRC_Settings__c.getInstance(csName);
        if (brcItem == null) {
            return '';
        } else {
            return brcItem.Value__c;
        }
    }
}