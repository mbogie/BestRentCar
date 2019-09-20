public with sharing class BRCDiscountController {

    @AuraEnabled
    public static List<Pricebook2> getAllPricebooks(){
        List<Pricebook2> pricebookList = new List<Pricebook2>();
        pricebookList = [SELECT Id,Name,Start_Date__c,End_Date__c,IsActive FROM Pricebook2];
        return pricebookList;
    }

    @AuraEnabled
    public static void createPb(Pricebook2 pricebook){
        Pricebook2 newPricebook = (Pricebook2) pricebook;
        insert newPricebook;
    }

}