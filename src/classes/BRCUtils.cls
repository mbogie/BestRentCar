public with sharing class BRCUtils {

    public static String getCredentialsValues(String csName) {
        Cs_Settings__c csItem = Cs_Settings__c.getInstance(csName);
        if (csItem == null) {
            return '';
        } else {
            return csItem.Value__c;
        }
    }
}