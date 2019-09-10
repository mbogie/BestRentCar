trigger BRCChangeVisibility on ContentDocumentLink (before insert, after insert ) {
    BRCTriggerFactory.createHandler(ContentDocumentLink.SObjectType);
}