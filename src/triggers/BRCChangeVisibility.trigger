trigger BRCChangeVisibility on ContentDocumentLink (before insert) {
    BRCTriggerFactory.createHandler(ContentDocumentLink.SObjectType);

}