/**
 * Remote actions for DSR page
 */
public with sharing class DSRRemote {
    public DSRRemote(ApexPages.StandardController ctrl) {
    }
    
    
    @RemoteAction
    public static DSRUIModel.CalendarItem[] jsrFetchCalendarDates(String siteId) {
        DSRUIModel.CalendarRequest calReq = new DSRUIModel.CalendarRequest();
        calReq.siteId = siteId;
        return EVAPI.DataSource.loadCalendar(calReq).dates;
    }

    @RemoteAction
    public static DSRUIModel.Topic[] jsrFetchAPITopics(String siteId) {
        DSRUIModel.TopicsRequest topicReq = new DSRUIModel.TopicsRequest();
        topicReq.siteId = siteId;
        return EVAPI.DataSource.loadTopics(topicReq).topics;
    }

    @RemoteAction
    public static Boolean jsrDeleteTopic(Id topicId) {
        Schema.DescribeSObjectResult dsor = Schema.Briefing_Topic__c.getSobjectType().getDescribe();
        if (dsor.isDeletable()) {
        	Database.delete(topicId);
        } else {
            throw new SFDCAccessControlException('Access Violation', 
														SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION, 
														SFDCAccessControlException.ExceptionReason.NO_DELETE,
														dsor.getName(),
														null);
        }
        return true;
    }
    
    @RemoteAction
    public static DSRUIModel.Topic[] jsrUpsertTopic(DSRUIModel.Topic topic) {
        List<Schema.SObjectField> fields = new List<Schema.SObjectField> {
                Briefing_Topic__c.Category_Name__c,
                Briefing_Topic__c.Category_Id__c,
                Briefing_Topic__c.Topic_Id__c,
                Briefing_Topic__c.Notes__c
		};
        Utils.Auth.assertAuthorizedToCreate(Schema.Briefing_Topic__c.getSobjectType(), fields);
        Utils.Auth.assertAuthorizedToUpdate(Schema.Briefing_Topic__c.getSobjectType(), fields);
        
        Briefing_Topic__c bt = topic.toBriefingTopicRecord(); 
        if(Schema.sObjectType.Briefing_Topic__c.isAccessible() && Schema.sObjectType.Briefing_Topic__c.isUpdateable()
               && Schema.sObjectType.Briefing_Topic__c.isCreateable()){ 
        upsert bt;  
               }
        topic.id = bt.id;
        
        return new DSRUIModel.Topic[]{topic};
    }
    
    @RemoteAction
    public static DSRUIModel.Topic[] jsrFetchDSRTopics(String dsrId) {
        List<Schema.SObjectField> fields = new List<Schema.SObjectField> {
                Briefing_Topic__c.Category_Name__c,
                Briefing_Topic__c.Category_Id__c,
                Briefing_Topic__c.Topic_Id__c,
                Briefing_Topic__c.Deal_Support_Request__c,
                Briefing_Topic__c.Notes__c
		};
        Utils.Auth.assertAuthorizedToView(Schema.Briefing_Topic__c.getSobjectType(), fields);
        
        DSRUIModel.Topic[] topics = new DSRUIModel.Topic[]{};
        for (Briefing_Topic__c bt: [Select Id, Name, Topic_Id__c, Category_Id__c, Notes__c, 
                                    Category_Name__c, Deal_Support_Request__c from Briefing_Topic__c Where Deal_Support_Request__c =:dsrId ]) {
            topics.add(new DSRUIModel.Topic(bt));
        }
        return topics;
    }
}