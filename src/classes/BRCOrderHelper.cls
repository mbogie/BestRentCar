public with sharing class BRCOrderHelper {

    public static final String BRC_COMMUNITY_ACCOUNT = BRCUtils.getValues('CommunityAccountId');
    public static final String STANDARD_PRICEBOOK = BRCUtils.getValues('StandardPricebookId');
    public static final List<String> ORDER_STATUS = BRCUtils.getOrdersStatusList();

    public static Id getOrderId(Id contractId, Order orderFromSite) {
        Order newOrder = orderFromSite;
        newOrder.AccountId = BRC_COMMUNITY_ACCOUNT;
        newOrder.Status = ORDER_STATUS.get(0);
        newOrder.ContractId = contractId;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = STANDARD_PRICEBOOK;
        Database.UpsertResult result = Database.upsert(newOrder);
        return (result.isSuccess()) ? result.getId() : null;
    }

    public static OrderItem createOrderItem(String productId, Integer days, Id orderId, Decimal price){
        OrderItem item = new OrderItem();
        item.PricebookEntryId = BRCPricebookHelper.getPricebookEntry(productId);
        item.Quantity = days;
        item.OrderId = orderId;
        item.Product2Id = productId;
        item.UnitPrice = price;
        return item;
    }

    public static void activateOrder(Id orderId){
        Order updateOrder = new Order(Id = orderId, Status = ORDER_STATUS.get(2));
        upsert updateOrder;
    }

    public static List<Order> getOrdersByUserId(Id userId){
        return [SELECT Id, Status, EffectiveDate, TotalAmount, (SELECT Id, UnitPrice, Quantity, TotalPrice, OrderId, Product2Id, Product2.Name FROM OrderItems) FROM Order WHERE ContractId = :BRCContractHelper.getContractId(userId) ORDER BY CreatedDate DESC];
    }
}