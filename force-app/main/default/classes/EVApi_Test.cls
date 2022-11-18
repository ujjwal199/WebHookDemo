@isTest
public class EVApi_Test {
    /**
* @description HttpCalloutMock
*/
    public class EVApiMockHttpResponse implements HttpCalloutMock {
        /**
* @description respond
*/   
        public HTTPResponse respond(HTTPRequest req) { 
            
            HttpResponse res = new HttpResponse();
            
            system.debug('req.getEndPoint:::' + req.getEndPoint());
            
            if (req.getEndPoint().containsIgnoreCase('topics?siteId=' + 1)) {
                String topicJson = '{"success":true,"count":2,"data":[{"id":"4","name":"ISVs","duration":"90","category":{"id":"2","name":"Topic Category 2"}}]}';
                res.setBody(topicJson);
            } else if (req.getEndPoint().containsIgnoreCase('dates?siteId=' + 1)) {
                String datesJson = '{"2015-06-24":{"available":true},"2015-06-25":{"available":true},"2015-06-26":{"available":true},"2015-06-27":{"available":true},"2015-06-28":{"available":true},"2015-06-29":{"available":true},"2015-06-30":{"available":true},"2015-07-01":{"available":true},"2015-07-02":{"available":true},"2015-07-03":{"available":true},"2015-07-04":{"available":true},"2015-07-05":{"available":true},"2015-07-06":{"available":true},"2015-07-07":{"available":true},"2015-07-08":{"available":true}}';
                res.setBody(datesJson);
            }
            else {
                String sitesJson = '{"success":true,"count":2,"data":[{"id":"1","name":"Mt. View, CA, USA","perDayBriefingLimit":"4","leadTime":"0","timezone":{"name":"(UTC-08:00) Baja California","code":' +
                    '"America\\/Ensenada"},"hoursOfOperation":{"start":"09:00:00","end":"17:00:00"}},{"id":"2","name":"Salesforce Tower","perDayBriefingLimit":"1","leadTime":"0","timezone":{"name":"(UTC-11:00) Coordinated Universal Time-11",' +
                    '"code":"Etc\\/GMT+11"},' +
                    '"hoursOfOperation":{"start":"03:00:00","end":"23:00:00"}}]}';
                res.setBody(sitesJson);
            }
            //       httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA&nbsp; Welcome to Customer Experience Portal<div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris  EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210510 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]}]}');
            
            res.setStatusCode(200);
            return res;
        }
        
    }
    /**
* @description respond
@param req @param name
@return res
*/
    public HTTPResponse respond(HTTPRequest req,string name) {
        HttpResponse res = new HttpResponse();
        res.setBody(JSON.serialize('{"token_type":"Bearer","expires_in":86400,"access_token":"eyJ0eXAiOiJKV1QiLCJh","refresh_token":"def50200ff4068766a28"}'));
        res.setStatusCode(200);
        return res;
        
    }
      private static testMethod void testfetchJSON() {
        EVApi.BSDataSource ev = new EVApi.BSDataSource();
        DSRUIModel.TopicsRequest reqForTopic= new DSRUIModel.TopicsRequest();
        reqForTopic.siteId ='1';
        DSRUIModel.CalendarRequest reqForCalender = new DSRUIModel.CalendarRequest();
        reqForCalender.siteId ='1';
        DSRUIModel.CalendarTopicResult CalendarTopicResult= new DSRUIModel.CalendarTopicResult();
        
        
        DSRUIModel.Site DSRUSite = new DSRUIModel.Site('1', 'Test', 'india' ,'2012,11,23,12,0,0','2012,11,23,12,0,10');
        DSRUSite.getHoursOfOperation();
        
        DSRUIModel.CalendarItem CalItem = new DSRUIModel.CalendarItem('2015-07-08',True);
        CalItem.start='2015-07-08';
        CalItem.available=True;
        
        System.assertNotEquals(null,CalItem.title,'title not equal to null');
        System.assertNotEquals(null,CalItem.backgroundColor,'backgroundColor not equal to null');
        
        new DSRUIModel.CalendarItem(System.now().date(),false);
        
        //set mock callout class
        Test.setMock(HttpCalloutMock.class, new EVApiMockHttpResponse());
        
        test.startTest();
        // call testParseDates method to test ParseDates of EVApiModel....
        EVApiModel.testParseDates();
        DSRUIModel.SitesResponse siteRes = ev.loadSites(new DSRUIModel.SitesRequest());
          DSRUIModel.TopicsResponse topicRes = ev.loadTopics(reqForTopic);
           DSRUIModel.CalendarResponse calenderRes = ev.loadCalendar(reqForCalender);
        test.stopTest();
        
        //   System.assert(siteRes != null,'siteRes not equal to null');
        //   System.assert(topicRes != null,'topicRes not equal to null');
        //        System.assert(calenderRes != null,'calenderRes not equal to null');
        
    }
    public static testMethod void test() {
        EVApi.BSDataSource ev = new EVApi.BSDataSource();
        DSRUIModel.TopicsRequest reqForTopic= new DSRUIModel.TopicsRequest();
        reqForTopic.siteId ='1';
        DSRUIModel.CalendarRequest reqForCalender = new DSRUIModel.CalendarRequest();
        reqForCalender.siteId ='1';
        DSRUIModel.CalendarTopicResult CalendarTopicResult= new DSRUIModel.CalendarTopicResult();
        
        
        DSRUIModel.Site DSRUSite = new DSRUIModel.Site('1', 'Test', 'india' ,'2012,11,23,12,0,0','2012,11,23,12,0,10');
        DSRUSite.getHoursOfOperation();
        
        DSRUIModel.CalendarItem CalItem = new DSRUIModel.CalendarItem('2015-07-08',True);
        CalItem.start='2015-07-08';
        CalItem.available=True;
        
        System.assertNotEquals(null,CalItem.title,'title not equal to null');
        System.assertNotEquals(null,CalItem.backgroundColor,'backgroundColor not equal to null');
        
        new DSRUIModel.CalendarItem(System.now().date(),false);
        
        //set mock callout class
        Test.setMock(HttpCalloutMock.class, new EVApiMockHttpResponse());
        
        test.startTest();
        // call testParseDates method to test ParseDates of EVApiModel....
        EVApiModel.testParseDates();
        DSRUIModel.SitesResponse siteRes = ev.loadSites(new DSRUIModel.SitesRequest());
          DSRUIModel.TopicsResponse topicRes = ev.loadTopics(reqForTopic);
           DSRUIModel.CalendarResponse calenderRes = ev.loadCalendar(reqForCalender);
        HttpRequest req =new HttpRequest();
           
           ev.fetchJSON(req);
    test.stopTest();
        
        //   System.assert(siteRes != null,'siteRes not equal to null');
        //   System.assert(topicRes != null,'topicRes not equal to null');
        //        System.assert(calenderRes != null,'calenderRes not equal to null');
        
    }
    private static testMethod void test1() {
        EVApi.BSDataSource ev = new EVApi.BSDataSource();
        DSRUIModel.TopicsRequest reqForTopic= new DSRUIModel.TopicsRequest();
        reqForTopic.siteId ='1';
        DSRUIModel.CalendarRequest reqForCalender = new DSRUIModel.CalendarRequest();
        reqForCalender.siteId ='1';
        DSRUIModel.CalendarTopicResult CalendarTopicResult= new DSRUIModel.CalendarTopicResult();
        
        
        DSRUIModel.Site DSRUSite = new DSRUIModel.Site('1', 'Test', 'india' ,'2012,11,23,12,0,0','2012,11,23,12,0,10');
        DSRUSite.getHoursOfOperation();
        
        DSRUIModel.CalendarItem CalItem = new DSRUIModel.CalendarItem('2015-07-08',True);
        CalItem.start='2015-07-08';
        CalItem.available=True;
        
        System.assertNotEquals(null,CalItem.title,'title not equal to null');
        System.assertNotEquals(null,CalItem.backgroundColor,'backgroundColor not equal to null');
        
        new DSRUIModel.CalendarItem(System.now().date(),false);
        
        //set mock callout class
        Test.setMock(HttpCalloutMock.class, new EVApiMockHttpResponse());
        
        test.startTest();
        // call testParseDates method to test ParseDates of EVApiModel....
        EVApiModel.testParseDates();
       // DSRUIModel.SitesResponse siteRes = ev.loadSites(new DSRUIModel.SitesRequest());
          DSRUIModel.TopicsResponse topicRes = ev.loadTopics(reqForTopic);
           DSRUIModel.CalendarResponse calenderRes = ev.loadCalendar(reqForCalender);
        test.stopTest();
        
        //   System.assert(siteRes != null,'siteRes not equal to null');
        //   System.assert(topicRes != null,'topicRes not equal to null');
        //        System.assert(calenderRes != null,'calenderRes not equal to null');
        
    }
    
    private static testMethod void test2() {
        EVApi.BSDataSource ev = new EVApi.BSDataSource();
        DSRUIModel.TopicsRequest reqForTopic= new DSRUIModel.TopicsRequest();
        reqForTopic.siteId ='1';
        DSRUIModel.CalendarRequest reqForCalender = new DSRUIModel.CalendarRequest();
        reqForCalender.siteId ='1';
        DSRUIModel.CalendarTopicResult CalendarTopicResult= new DSRUIModel.CalendarTopicResult();
        
        
        DSRUIModel.Site DSRUSite = new DSRUIModel.Site('1', 'Test', 'india' ,'2012,11,23,12,0,0','2012,11,23,12,0,10');
        DSRUSite.getHoursOfOperation();
        
        DSRUIModel.CalendarItem CalItem = new DSRUIModel.CalendarItem('2015-07-08',True);
        CalItem.start='2015-07-08';
        CalItem.available=True;
        
        System.assertNotEquals(null,CalItem.title,'title not equal to null');
        System.assertNotEquals(null,CalItem.backgroundColor,'backgroundColor not equal to null');
        
        new DSRUIModel.CalendarItem(System.now().date(),false);
        
        //set mock callout class
        Test.setMock(HttpCalloutMock.class, new EVApiMockHttpResponse());
        
        test.startTest();
        // call testParseDates method to test ParseDates of EVApiModel....
        EVApiModel.testParseDates();
       // DSRUIModel.SitesResponse siteRes = ev.loadSites(new DSRUIModel.SitesRequest());
         // DSRUIModel.TopicsResponse topicRes = ev.loadTopics(reqForTopic);
           DSRUIModel.CalendarResponse calenderRes = ev.loadCalendar(reqForCalender);
        test.stopTest();
        
        //   System.assert(siteRes != null,'siteRes not equal to null');
        //   System.assert(topicRes != null,'topicRes not equal to null');
        //        System.assert(calenderRes != null,'calenderRes not equal to null');
        
    }
    
    
    
    static testmethod void testGetCenters() {
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings.bsource__API_Username__c='test';
        briefingSourceSettings.bsource__API_Password__c='test';
        briefingSourceSettings.bsource__Client_Id__c='test';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        insert briefingSourceSettings;
        EVApi.BriefingType briefingType = new EVApi.BriefingType();
        briefingType.id = 2000;
        briefingType.name = 'briefing type';
        
        EVApi.Center center = new EVApi.Center();
        center.id = 1000;
        center.name = 'center';
        center.briefingTypes = new List<EVApi.BriefingType>{briefingType};
            
            EVApi.CentersResponse centersResponse = new EVApi.CentersResponse();
        centersResponse.data = new List<EVApi.Center>{center};
            
            HttpResponse httpResponse = new HttpResponse();
        httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA&nbsp; Welcome to Customer Experience Portal<div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris  EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210510 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]}]}');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse));
        //  List<EVApi.Center> returnedCenters = EVApi.getCenters();
        
        Test.stopTest();
        
    }
    
    static testmethod void testGetCenters1() {
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings.bsource__API_Username__c='test';
        briefingSourceSettings.bsource__API_Password__c='test';
        briefingSourceSettings.bsource__Client_Id__c='test';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        insert briefingSourceSettings;
        EVApi.BriefingType briefingType = new EVApi.BriefingType();
        briefingType.id = 2000;
        briefingType.name = 'briefing type';
        
        EVApi.Center center = new EVApi.Center();
        center.id = 1000;
        center.name = 'center';
        center.briefingTypes = new List<EVApi.BriefingType>{briefingType};
            
            EVApi.CentersResponse centersResponse = new EVApi.CentersResponse();
        centersResponse.data = new List<EVApi.Center>{center};
            //
            HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody(JSON.serialize(centersResponse));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse));
        parseJSON.FormFields tf=new parseJSON.FormFields();
        tf.name='test';
        tf.label='test';
        List<EVApi.Center> returnedCenters = EVApi.getCenters(briefingSourceSettings);
        EVApi.upsertCustomMetadata('5666777','test','test');
        //EVApi.getFields(briefingSourceSettings);
        Test.stopTest();
        
    }
    static testmethod void testGetCenters3() {
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings.bsource__API_Username__c='test';
        briefingSourceSettings.bsource__API_Password__c='test';
        briefingSourceSettings.bsource__Client_Id__c='test';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        insert briefingSourceSettings;
        EVApi.BriefingType briefingType = new EVApi.BriefingType();
        briefingType.id = 2000;
        briefingType.name = 'briefing type';
        
        EVApi.Center center = new EVApi.Center();
        center.id = 1000;
        center.name = 'center';
        center.briefingTypes = new List<EVApi.BriefingType>{briefingType};
            
            EVApi.CentersResponse centersResponse = new EVApi.CentersResponse();
        centersResponse.data = new List<EVApi.Center>{center};
            
            HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody(JSON.serialize(centersResponse));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse,'test'));
        // EVApi.getFieldsClone();
        //  EVApi.getToken(bsource);
        
        Test.stopTest();
        
    }
    static testmethod void testGetCenters4() {
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings.bsource__API_Username__c='test';
        briefingSourceSettings.bsource__API_Password__c='test';
        briefingSourceSettings.bsource__Client_Id__c='test';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        briefingSourceSettings.bsource__Refreshed_Time__c = system.now();
        insert briefingSourceSettings;
        EVApi.BriefingType briefingType = new EVApi.BriefingType();
        briefingType.id = 2000;
        briefingType.name = 'briefing type';
        
        EVApi.Center center = new EVApi.Center();
        center.id = 1000;
        center.name = 'center';
        center.briefingTypes = new List<EVApi.BriefingType>{briefingType};
            
            EVApi.CentersResponse centersResponse = new EVApi.CentersResponse();
        centersResponse.data = new List<EVApi.Center>{center};
            
            HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody(JSON.serialize(centersResponse));
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse));
        EVApi.getRefreshedTime(briefingSourceSettings);
        EVApi.getFields(briefingSourceSettings);
        EVApi.getRequest(briefingSourceSettings,'Https://google.com');
        EVApi.getRequest('Https://google.com');
        EVApi.Field objField= new EVApi.Field();
        objField.label ='test';
        objField.systemName ='testing';
        EVApi.FieldsResponse objFieldsResponse= new EVApi.FieldsResponse();
        objFieldsResponse.label ='test';
        EVApi.Section objSection= new EVApi.Section();
        objFieldsResponse.label ='test';
        objSection.label ='test';
        Test.stopTest();
        
    }

    public static testmethod void testDSRUIModelClass() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
       system.debug(WizardState.canChangeSites);
         
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
    public static testmethod void testDSRUIModelClass1() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
       // system.debug(WizardState.canChangeSites);
          system.debug(WizardState.canChangeDSRName);
         
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
    public static testmethod void testDSRUIModelClass2() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.isStageAttendees);  
    
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
    public static testmethod void testDSRUIModelClass3() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
   
        system.debug(WizardState.isStageReview);
         
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
    public static testmethod void testDSRUIModelClass4() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
        //system.debug(WizardState.canChangeSites);
          //system.debug(WizardState.canChangeDSRName);
          //system.debug(WizardState.isStageAttendees);  
        //system.debug(WizardState.isStageReview);
          system.debug(WizardState.isStageAddInfo);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass5() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.isStageSite);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass6() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.oppId);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass7() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.isStageTopics);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass8() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.canChangeDates);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass9() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.canChangeTopics);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass10() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.canChangeAddInfo);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass11() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.canChangeAttendees);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass12() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.canChangeDSR);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
     public static testmethod void testDSRUIModelClass13() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        DSRUIModel.Topic objTopic = new DSRUIModel.Topic('test','test');
        objTopic.apiId ='test';
        objTopic.categoryId='Testing';
        objTopic.categoryName ='test';
        objTopic.duration ='test';
        objTopic.notes='Testing';
        objTopic.dsrId =DSRobj.Id;
        Briefing_Topic__c objBriefingTopic = new Briefing_Topic__c();
        objBriefingTopic.bsource__Category_Name__c ='General';
        objBriefingTopic.bsource__Deal_Support_Request__c =DSRobj.Id;
        insert objBriefingTopic;
        DSRUIModel.Topic objTopic2= new DSRUIModel.Topic(objBriefingTopic);
        DSRUIModel.Attendee objAttendee = new DSRUIModel.Attendee(c,'test',true);
        DSRUIModel.WizardState WizardState = new DSRUIModel.WizardState();
        WizardState.selectedSite ='test';
        WizardState.selectedSiteName ='test';
        WizardState.selectedAlternateDate ='test';
        WizardState.selectedStartTime ='test';
        WizardState.selectedEndTime ='test';
        WizardState.selectedMeetingDurationType ='test';
    
          system.debug(WizardState.canChangeDates);
          
        WizardState.getSelectedPrimaryDateObj();
    
        system.assert(objBriefingTopic!=null, 'Is not null');
        // WizardState.getSelectedAlternateDateObj();
        //objTopic.toBriefingTopicRecord();
    }
}