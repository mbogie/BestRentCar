public with sharing class BRCOrdersListController {

    @AuraEnabled
    public static List<Order> getOrderList() {
        try {
            Contract userContract = [SELECT Id FROM Contract WHERE CreatedById = :UserInfo.getUserId() LIMIT 1];
            List<Order> ordersList = [SELECT Id, Status, EffectiveDate, TotalAmount, (SELECT Id, UnitPrice, Quantity, TotalPrice, OrderId, Product2Id, Product2.Name FROM OrderItems) FROM Order WHERE ContractId = :userContract.Id ORDER BY CreatedDate DESC];
            return ordersList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}