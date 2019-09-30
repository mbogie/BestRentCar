public with sharing class BRCCartPageController {

    public static final String BRC_COMMUNITY_ACCOUNT = BRCUtils.getValues('CommunityAccountId');
    public static final String STANDARD_PRICEBOOK = BRCUtils.getValues('StandardPricebookId');
    public static final List<String> ORDER_STATUS = BRCUtils.getOrdersStatusList();
    public static final List<String> CONTRACT_STATUS = BRCUtils.getContractStatusList();

    public class BasketWrapper {
        public Integer days;
        public PricebookEntry price;
        public Product2 product;
    }

    @AuraEnabled
    public static void createOrder(Order newOrder, String wrapperList) {
        try {
            List<BRCCartPageController.BasketWrapper> wrappers = (List<BRCCartPageController.BasketWrapper>) JSON.deserialize(wrapperList, List<BRCCartPageController.BasketWrapper>.class);
            Id contractId = getContractId(UserInfo.getUserId());
            Id orderId = getOrderId(contractId, newOrder);
            List<OrderItem> orderItemList = new List<OrderItem>();
            for (BasketWrapper wrapper : wrappers) {
                OrderItem item = new OrderItem();
                item.PricebookEntryId = getPricebookEntry(wrapper.product.Id);
                item.Quantity = wrapper.days;
                item.OrderId = orderId;
                item.Product2Id = wrapper.product.Id;
                item.UnitPrice = wrapper.price.UnitPrice;
                orderItemList.add(item);
            }
            upsert orderItemList;
            Order updateOrder = new Order(Id = orderId, Status = ORDER_STATUS.get(2));
            upsert updateOrder;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(System.Label.BRC_Server_Error);
        }
    }

    private static Id getPricebookEntry(Id productId) {
        List<PricebookEntry> entries = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :STANDARD_PRICEBOOK];
        return entries.get(0).Id;
    }

    private static Id getContractId(Id userId) {
        List<Contract> contractList = new List<Contract>();
        contractList = [SELECT Id, CustomerSignedId FROM Contract WHERE OwnerId = :userId];
        if (contractList.isEmpty()) {
            Contract newContract = new Contract();
            newContract.AccountId = BRC_COMMUNITY_ACCOUNT;
            newContract.Status = CONTRACT_STATUS.get(2);
            newContract.StartDate = System.today();
            newContract.ContractTerm = 1;
            Database.UpsertResult result = Database.upsert(newContract);
            if (result.isSuccess()) {
                newContract.Id = result.getId();
                newContract.Status = CONTRACT_STATUS.get(1);
                result = Database.upsert(newContract);
                return (result.isSuccess()) ? result.getId() : null;
            } else return null;
        } else {
            return contractList.get(0).Id;
        }
    }

    private static Id getOrderId(Id contractId, Order orderFromSite) {
        Order newOrder = orderFromSite;
        newOrder.AccountId = BRC_COMMUNITY_ACCOUNT;
        newOrder.Status = ORDER_STATUS.get(0);
        newOrder.ContractId = contractId;
        newOrder.EffectiveDate = System.today();
        newOrder.Pricebook2Id = STANDARD_PRICEBOOK;
        Database.UpsertResult result = Database.upsert(newOrder);
        return (result.isSuccess()) ? result.getId() : null;
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