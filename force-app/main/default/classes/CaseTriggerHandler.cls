public without sharing class CaseTriggerHandler extends TriggerHandler {
    
    protected override void beforeUpdate() {
        Map<Id,Case> caseNewMap = (Map<Id,Case>)Trigger.NewMap;
    	Map<Id,Case> caseOldMap = (Map<Id,Case>)Trigger.OldMap;
  		buildFeed(caseNewMap, caseOldMap);
    }
    
    
    private static void buildFeed (Map<Id,Case> caseNewMap,Map<Id,Case> caseOldMap){
        for(Id cs: caseNewMap.keyset()){
            if(!(caseNewMap.get(cs).Status).equals(caseOldMap.get(cs).Status)){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
                ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                String caseNum = caseNewMap.get(cs).caseNumber;
                textSegmentInput1.text = 'È stato sollecitato il Case numero ' + caseNum + ' (';
                
                messageBodyInput.messageSegments.add(textSegmentInput1);
                //aggiungo la notifica a operatore owner del case
                mentionSegmentInput.id = caseNewMap.get(cs).OwnerId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                textSegmentInput2.text = ')';
                messageBodyInput.messageSegments.add(textSegmentInput2);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                
                //aggancio il feed al titolare del case
                feedItemInput.subjectId = caseNewMap.get(cs).OwnerId;
                system.debug('feedItemInput>>'+feedItemInput);
            }
        }
    }
}