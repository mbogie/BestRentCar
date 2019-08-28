public with sharing class BRCProductDetailController {
    @AuraEnabled
    public static List<String> getProductImages(Id recordId) {
        List<String> listOfUrls = new List<String>();
        List<Product_Image__c> listOfProductImages = [
                SELECT Id, Image_Url__c, Image__c
                FROM Product_Image__c
                WHERE Product__c = :recordId
        ];

        if (!listOfProductImages.isEmpty()) {
            for (Product_Image__c image : listOfProductImages) {
                System.debug(image);

                String imgUrl = image.Image__c.substringBetween(' src="', '"').unescapeHtml4();
                listOfUrls.add(imgUrl);
            }
        }
        System.debug(listOfUrls);
        return listOfUrls;
    }
}