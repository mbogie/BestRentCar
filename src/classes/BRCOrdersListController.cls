public with sharing class BRCOrdersListController {

    @AuraEnabled
    public static List<Order> getOrderList() {
        try {
            return BRCOrderHelper.getOrdersByUserId(UserInfo.getUserId());
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}