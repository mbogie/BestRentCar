public with sharing class BRCAccountHelper {

    public static List<Account> getAccounts(String country, String city, String state){
        List<Account> resultList = new List<Account>();
        BRCQueryBuilder queryBuilder = new BRCQueryBuilder();
        queryBuilder.addResultField('Id').
                addResultField('Name').
                addResultField('BillingCity').
                addResultField('BillingCountry').
                addResultField('BillingAddress').
                addResultField('BillingState').
                addResultField('BillingPostalCode').
                addResultField('BillingStreet').
                addTableName('Account').
                addSearchFieldStartsWithValue('BillingCountry', country).
                addSearchFieldStartsWithValue('BillingState', state).
                addSearchFieldStartsWithValue('BillingCity', city).
                addSearchFieldEqualsWithValue('RecordType.Name',BRCUtils.getValues('DivisionsSearchRecordType')).
                build();
        resultList = Database.query(queryBuilder.getQueryString());
        return resultList;
    }
}