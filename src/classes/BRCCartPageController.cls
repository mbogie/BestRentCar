public with sharing class BRCCartPageController {

    public class BasketWrapper {
        public Integer days;
        public PricebookEntry price;
        public Product2 product;
    }

    @AuraEnabled
    public static void createOrder(Order newOrder, String wrapperList) {
        try {
            List<BRCCartPageController.BasketWrapper> wrappers = (List<BRCCartPageController.BasketWrapper>) JSON.deserialize(wrapperList, List<BRCCartPageController.BasketWrapper>.class);
            Id orderId = BRCOrderHelper.getOrderId(BRCContractHelper.getContractId(UserInfo.getUserId()), newOrder);
            List<OrderItem> orderItemList = new List<OrderItem>();
            for (BasketWrapper wrapper : wrappers) {
                orderItemList.add(BRCOrderHelper.createOrderItem(wrapper.product.Id, wrapper.days, orderId, wrapper.price.UnitPrice));
            }
            upsert orderItemList;
            BRCOrderHelper.activateOrder(orderId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    @AuraEnabled
    public static User getContractAddress() {
        try {
            return BRCUtils.getUserAddress();
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }
}