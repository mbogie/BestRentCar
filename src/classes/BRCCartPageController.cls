public with sharing class BRCCartPageController {

    @AuraEnabled
    public static void createOrder(Order newOrder, List<Object> wrapperList){
        System.debug(newOrder);
        for(Object obj : wrapperList){
            System.debug(obj);
        }
    }

}