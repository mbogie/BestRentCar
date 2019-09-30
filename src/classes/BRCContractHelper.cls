public with sharing class BRCContractHelper {

    public static final List<String> CONTRACT_STATUS = BRCUtils.getContractStatusList();
    public static final String BRC_COMMUNITY_ACCOUNT = BRCUtils.getValues('CommunityAccountId');

    public static Id getContractId(Id userId) {
        List<Contract> contractList = new List<Contract>();
        contractList = [SELECT Id FROM Contract WHERE CreatedById = :userId AND AccountId = :BRC_COMMUNITY_ACCOUNT];
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
}