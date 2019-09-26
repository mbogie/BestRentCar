public with sharing class BRCUtils {

    public static String getValues(String brcName) {
        BRC_Settings__c brcItem = BRC_Settings__c.getInstance(brcName);
        if (brcItem == null) {
            return '';
        } else {
            return brcItem.Value__c;
        }
    }
}