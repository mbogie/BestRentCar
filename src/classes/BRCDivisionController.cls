public with sharing class BRCDivisionController {

    @AuraEnabled
    public static List <Account> getAccounts(String country, String city, String state) {
        BRCQueryBuilder queryBuilder = new BRCQueryBuilder();
        queryBuilder.addResultField('Id').
                addResultField('Name').
                addResultField('BillingCity').
                addResultField('BillingCountry').
                addResultField('BillingAddress').
                addResultField('BillingState').
                addResultField('BillingPostalCode').
                addResultField('BillingStreet').
                addResultField('Website').
                addResultField('Fax').
                addTableName('Account').
                addSearchFieldStartsWithValue('BillingCountry', country).
                addSearchFieldStartsWithValue('BillingState', state).
                addSearchFieldStartsWithValue('BillingCity', city).
                build();
        System.debug('aaa -- > ' + queryBuilder.getQueryString());
        return Database.query(queryBuilder.getQueryString());
    }

    @AuraEnabled
    public static List<Location> getAccount() {
        List< Account> accs =  [Select Id, Name,Type, Industry, BillingAddress,BillingStreet,
                BillingCity, BillingCountry, BillingPostalCode,
                BillingState,Phone from Account] ;

        List<Location> loc = new List<Location>();
        for(Account acc :accs){
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = acc.BillingStreet;
            geoInfo.PostalCode = acc.BillingPostalCode;
            geoInfo.City = acc.BillingCity;
            geoInfo.State = acc.BillingState;
            geoInfo.Country = acc.BillingCountry;
            Location locDetail = new Location();
            locDetail.icon = 'action:map';
            locDetail.title = acc.Name;
            locDetail.description = acc.Name;
            locDetail.location = geoInfo;

            loc.add(locDetail);
        }
        return loc ;
    }
    public class Location{
        @AuraEnabled
        public String icon{get;set;}
        @AuraEnabled
        public String title{get;set;}
        @AuraEnabled
        public String description{get;set;}
        @AuraEnabled
        public GeoLocation location{get;set;}
    }
    public class GeoLocation{
        @AuraEnabled
        public String Street{get;set;}
        @AuraEnabled
        public String PostalCode{get;set;}
        @AuraEnabled
        public String City{get;set;}
        @AuraEnabled
        public String State{get;set;}
        @AuraEnabled
        public String Country{get;set;}
    }
}