global class BRCPostToChatterAction {

    @InvocableMethod(label='Post to Chatter')
    global static List<ChatterPostResult> postToChatter(List<ChatterPost> chatterMessages)
    {
        Map<String, List<ConnectApi.FeedItemInput>> communityToChatterPosts = new Map<String, List<ConnectApi.FeedItemInput>>();
        for(ChatterPost msg : chatterMessages)
        {
            ConnectApi.FeedItemInput feedItem =
                    (ConnectApi.FeedItemInput) BRCConnectApiHelper.createFeedItemWithMentions(msg.subjectId, msg.message);

            if(communityToChatterPosts.containsKey(msg.communityId)){ communityToChatterPosts.get(msg.communityId).add(feedItem); }
            else { communityToChatterPosts.put(msg.communityId, new ConnectApi.FeedItemInput[]{ feedItem }); }
        }

        List<ConnectApi.BatchResult> batchResults = new List<ConnectApi.BatchResult>();
        for(String communityId : communityToChatterPosts.keySet()){
            batchResults.addAll(
                    BRCConnectApiHelper.postFeedItemBatch(
                            communityId,
                            communityToChatterPosts.get(communityId)));
        }

        List<ChatterPostResult> results = new List<ChatterPostResult>();
        for(ConnectApi.BatchResult r : batchResults){
            ChatterPostResult cpr = new ChatterPostResult();
            cpr.isSuccess = r.isSuccess();
            cpr.errorMessage = r.getErrorMessage();
            results.add(cpr);
        }
        return results;
    }

    global class ChatterPost {
        @InvocableVariable(label='Community Id' description='Use either the ID of a community, "internal", or null.')
        global String communityId;

        @InvocableVariable(required=true label='Subject Id' description='The parent of the post. Can be a user ID, a group ID, or a record ID.')
        global Id subjectId;

        @InvocableVariable(required=true label='Message' description='Chatter Post message.')
        global String message;
    }

    global class ChatterPostResult {
        @InvocableVariable(label='Is Success?' description='TRUE if chatter post has been posted successfully, otherwise FALSE.')
        global Boolean isSuccess;

        @InvocableVariable(label='Error Message' description='Reason why the posting failed.')
        global String errorMessage;
    }
}