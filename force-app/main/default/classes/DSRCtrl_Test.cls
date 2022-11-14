/**
*
@description DSRCtrl_Test
*/
@IsTest
public class DSRCtrl_Test {
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        /**
*
@description respond
@param req
*/
        public HTTPResponse respond(HTTPRequest req) {
            
            String jason = '{"success":true,"count":2,"data":[{"id":"1","name":"Mt. View, CA, USA","perDayBriefingLimit":"4","leadTime":"0","timezone":{"name":"(UTC-08:00) Baja California","code":' +
                '"America\\/Ensenada"},"hoursOfOperation":{"start":"09:00:00","end":"17:00:00"}},{"id":"2","name":"Salesforce Tower","perDayBriefingLimit":"1","leadTime":"0","timezone":{"name":"(UTC-11:00) Coordinated Universal Time-11",' +
                '"code":"Etc\\/GMT+11"},' +
                '"hoursOfOperation":{"start":"03:00:00","end":"23:00:00"}}]}';
            String jsnForSiteId1 = '{"success":true,"count":2,"data":[{"id":"1","name":"Mt. View, CA, USA","perDayBriefingLimit":"4","leadTime":"0","timezone":{"name":"(UTC-08:00) Baja California","code":' +
                '"America\\/Ensenada"},"hoursOfOperation":{"start":"09:00:00","end":"17:00:00"}}]}';
            String jasonSample = '{"2015-06-24":{"available":true},"2015-06-25":{"available":true},"2015-06-26":{"available":true},"2015-06-27":{"available":true},"2015-06-28":{"available":true},"2015-06-29":{"available":true},"2015-06-30":{"available":true},"2015-07-01":{"available":true},"2015-07-02":{"available":true},"2015-07-03":{"available":true},"2015-07-04":{"available":true},"2015-07-05":{"available":true},"2015-07-06":{"available":true},"2015-07-07":{"available":true},"2015-07-08":{"available":true}}';
            
            String jasonForTopic = '{"success":true,"count":2,"data":[{"id":"4","name":"ISVs","duration":"90","category":{"id":"2","name":"Topic Category 2"}}, {"id":"250","name":"EV Services and Support Overview","duration":"60","category":{"id":"12","name":"Security"}}]}';
            system.debug('req.getEndPoint:::' + req.getEndPoint());
            HttpResponse res = new HttpResponse();
            
            if (req.getEndPoint().containsIgnoreCase('dates?siteId=' + 1)) {
                res.setBody(jasonSample);
            } else if (req.getEndPoint().containsIgnoreCase('topics?siteId=' + 1)) {
                res.setBody(jasonForTopic);
            } else {
                res.setBody(jason);
            }
            
            res.setStatusCode(200);
            return res;
        }
        
    }
    
    /*
Creating a new Opportunity in a production org, with all the validation rules, is going to be problematic.
Attempt to test as many methods as possible with minimal dependency on mock data.
*/
    /**
*
@description TestDSRCtrl
*/
    public static testmethod void TestDSRCtrl() {
        MockFactory mockData = new MockFactory();
        //get the Contacts,opportunity, OpportunityContactRole, AccountContactRole records from MockFactory cls.
        Opportunity opp = mockData.Opp;
        List < Contact > contacts = mockData.con;
        List < OpportunityContactRole > oppConRoles = mockData.oppConRole;
        List < AccountContactRole > accConRoles = mockData.accConRole;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        DSRCtrl controller = new DSRCtrl(sc);
        System.debug('Vikas ::' + controller.state.probableAttendees);
        
        system.assertEquals(true,controller.state.isStageAttendees,'isStageAttendees should be true');
        system.assertEquals(false,controller.state.isStageTopics,'isStageTopics should be false');
        system.assertEquals(false,controller.state.isStageSite,'isStageSite should be false');
        system.assertEquals(false,controller.state.isStageAddInfo,'isStageAddInfo should be false');
        system.assertEquals(false,controller.state.isStageReview,'isStageReview should be false');
        
        system.assertEquals(true,controller.state.canChangeAttendees,'canChangeAttendees should be true');
        system.assertEquals(true,controller.state.canChangeDSR,'canChangeDSR should be true');
        
        // lets do the assert for the list of probable attendees.
        System.assertEquals(4, controller.state.probableAttendees.size(),'size should be 4');
        System.assertEquals('mark', controller.state.probableAttendees[0].contact.Name,'name  should be mark');
        System.assertEquals('Jim', controller.state.probableAttendees[1].contact.Name,'name should be Jim');
        System.assertEquals('Young', controller.state.probableAttendees[2].contact.Name,'name should be Young');
        System.assertEquals('Andy', controller.state.probableAttendees[3].contact.Name,'name should be Andy');
        
        // set the Deal Support Request Name at step first. 
        controller.state.dsr.Name = 'testDSR';
        controller.state.dsr.Site_ID__c = '1';
        controller.state.dsr.Site_Name__c = 'Mt. View, CA, USA';
        controller.state.dsr.Alternative_Date__c = date.valueOf('2015-07-01');
        controller.state.dsr.Primary_Date__c = date.valueOf('2015-06-30');
        
        // controller.state.dsr.Alternative_Date__c ='2015-07-01';
        
        system.assertEquals(true,controller.state.canChangeDates);
        
        // select the attendees from the probableAttendees list. 
        controller.state.probableAttendees[0].Selected = true;
        
        //go to the site section.
        controller.onSaveAttendees();
        //go back on the previous stage
        controller.movePreviousInWizard();
        controller.toStepAttendees();
        //change the attendee from the probableAttendees list.
        controller.state.probableAttendees[1].Selected = true;
        System.debug('vst ::' + controller.state.probableAttendees);
        controller.onSaveAttendees();
        
        test.startTest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     //   controller.gotoAttendeesNext();
     /*   String siteId = controller.state.sitesResponse.sites[0].Id;
        
        
        
        // select the site for the dsr.
        controller.state.selectedSite = siteId;
        controller.state.selectedSiteName = controller.state.sitesResponse.sites[0].Name;
        
        
        //call remote action jsrFetchCalendarDates to fetch calender dates.
        DSRRemote.jsrFetchCalendarDates(siteId);*/
        //String networkld = Network.getNetworkId(); 

        //DSRRemote.jsrFetchCalendarDates(networkld);
        //select the primary date and alternate date for the dsr.
        controller.state.selectedPrimaryDate = string.valueOf('2015-06-30');
        controller.state.selectedAlternateDate = string.valueOf('2015-07-01');
        
        //call remote action method of DSRRemote cls to fetch the ApiTopics.
       // List < DSRUIModel.topic > topicsList = DSRRemote.jsrFetchAPITopics(siteId);
        String dsrId = [SELECT Id FROM BS_Deal_Support_Request__c WHERE Opportunity__c = : opp.Id].Id;
        
        
        
        //select one topic from the fetched api topics and set TcanChangeDatesopic dsr Id for test.[0
        
      /*  topicsList[0].dsrId = dsrId;
        topicsList[0].notes = 'testing data';
        System.debug('vstData ::' + topicsList[0]);
        
        
        
        
        // go to the next section.
        controller.gotoSitesNext();
        
        // call remote action method jsrUpsertTopic of DSRRemote cls to upsert the dsr topic.
        DSRRemote.jsrUpsertTopic(topicsList[0]);
        
        //call the jsrDeleteTopic remote method to delete the briefing topic.
        DSRRemote.jsrDeleteTopic(topicsList[0].Id);
        
        //enter other briefing topic for dsr.
        topicsList[1].dsrId = dsrId;
        topicsList[1].notes = 'topic data';
        System.debug('vstData ::' + topicsList[1]);
        
        // call remote action method jsrUpsertTopic of DSRRemote cls to upsert the other dsr topic.
        DSRRemote.jsrUpsertTopic(topicsList[1]);*/
        // call remote action method of DSRRemote cls to fetch the dsr topic.
        DSRRemote.jsrFetchDSRTopics(dsrId);
        
      //  Briefing_Topic__c bt = [SELECT Name, Deal_Support_Request__c, Notes__c, Category_Name__c FROM Briefing_Topic__c WHERE Deal_Support_Request__c = : dsrId];
       // System.debug('bt ::' + bt);
        controller.gotoTopicsNext();
        // Do assert for Briefing topic.
       // System.assertEquals(dsrId, bt.Deal_Support_Request__c,'Deal_Support_Request__c should be dsrId');
       // System.assertEquals('EV Services and Support Overview', bt.Name,'Name should be EV Services and Support Overview');
       // System.assertEquals('topic data', bt.Notes__c,'Notes__c should be topic data');
      //  System.assertEquals('Security', bt.Category_Name__c,'Category_Name__c should be Security');
        
        //set the Dress code and Additional comment.
        controller.state.dsr.Dress_Code__c = 'Business Casual';
        controller.state.dsr.Additional_Comments__c = 'dsr for testing';
        
        // call gotoAddInfoNext method to move on next section.
      //  controller.gotoAddInfoNext();
        controller.toStepReview();
        controller.createDSR();
        //controller.fetchcurrentDSR();
        test.stopTest();
        // get Deal_Support_Request__c and Briefing_Attendee__c records created by DSRCtrl cls for assertions.
        BS_Deal_Support_Request__c dsr = [SELECT Id, Name, Site_ID__c, bsource__Site_Name__c, Alternative_Date__c, Primary_Date__c, Dress_Code__c, Additional_Comments__c FROM BS_Deal_Support_Request__c WHERE Opportunity__c = : opp.Id];
        System.debug('@@@@@'+dsr.Site_ID__c);
        System.debug('@@@@@'+dsr.Alternative_Date__c);
        Briefing_Attendee__c ba = [SELECT Deal_Support_Request__c FROM Briefing_Attendee__c WHERE Contact__c = : Contacts[0].Id];
        System.assert(controller != null,'controller not equal to null');
      //  System.debug('@@@@@'+controller.state.sitesResponse.sites[0].Id);
        //Do assert for Deal_Support_Request__c and Briefing_Attendee__c objects.
      //  System.assertEquals(controller.state.sitesResponse.sites[0].Id, dsr.Site_ID__c,'Site_ID__c should sites Response Security');
        
        System.assertEquals('Mt. View, CA, USA', dsr.bsource__Site_Name__c,'bsource__Site_Name__c should be equal to Mt. View, CA, USA');
        System.assertEquals(date.valueOf('2015-07-01'), dsr.Alternative_Date__c,'Alternative_Date__c should be equal to 2015-07-01');
        System.assertEquals(date.valueOf('2015-06-30'), dsr.Primary_Date__c,'Primary_Date__c should be equal to 2015-06-30');
        System.assertEquals(dsr.Id, ba.Deal_Support_Request__c,'Deal_Support_Request__c should be equal to dsr Id');
        System.assertEquals('testDSR', dsr.Name,'Name should be equal to testDSR');
        System.assertEquals('Business Casual', dsr.Dress_Code__c,'Dress_Code__c should be equal to Business Casual');
      //  System.assertEquals('dsr for testing', dsr.Additional_Comments__c,'Additional_Comments__c should be equal to dsr for testing');
       // System.assertEquals(dsrId, bt.Deal_Support_Request__c,'Deal_Support_Request__c should be equal to dsrId');
       // System.assertEquals('topic data', bt.Notes__c,'Notes__c should be equal to topic data');
       // System.assertEquals(topicsList[1].categoryName, bt.Category_Name__c,'Category_Name__c should be equal to categoryName');
        
        
        ApexPages.currentPage().getParameters().put('dsrId',dsr.id);
        ApexPages.currentPage().getParameters().put('stage','Attendees');
        controller = new DSRCtrl(sc);
        
        ApexPages.currentPage().getParameters().put('stage','Site');
        //controller = new DSRCtrl(sc);
        
        ApexPages.currentPage().getParameters().put('stage','Topics');
        //controller = new DSRCtrl(sc);
        
        ApexPages.currentPage().getParameters().put('stage','AddInfo');
        controller = new DSRCtrl(sc);
        
        ApexPages.currentPage().getParameters().put('stage','Review');
        controller = new DSRCtrl(sc);
        
        ApexPages.currentPage().getParameters().put('isStageTopics','isStageTopics');
        controller = new DSRCtrl(sc);
        
        ApexPages.currentPage().getParameters().put('isStageSite','isStageSite');
        controller = new DSRCtrl(sc);
        
        
        
        
        
        
        
        
    }
    /**
*
@description TestExternalAttendee
*/
    public static testmethod void TestExternalAttendee() {
        MockFactory mockData = new MockFactory();
        Opportunity opp = mockData.Opp;
        List < Contact > contacts = mockData.con;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        DSRCtrl controller = new DSRCtrl(sc);
        controller.state.dsr.Name = 'testDSR';
        controller.state.probableAttendees[0].Selected = true;
        
        test.startTest();
        
        controller.addNewRowAdHocAttendee();
        System.assertEquals(1,controller.state.adHocAttendees.size(),'size should be 1');
        
        controller.index=0;
        controller.removeAdHocAttendee();
        System.assertEquals(0,controller.state.adHocAttendees.size(),'size should be 0');
        
        controller.state.adHocAttendees=null;
        controller.addNewRowAdHocAttendee();
        controller.addNewRowAdHocAttendee();
        
        
        System.assertEquals(2,controller.state.adHocAttendees.size(),'size should be 2');
        
        controller.state.adHocAttendees.get(0).Email__c='Test@test.com';
        controller.state.adHocAttendees.get(1).Email__c='Test2@test.com';
        
        controller.verifyAdohAttendeeList();
        controller.AddToAttendeeList();
        
        System.assertEquals(2,controller.state.adHocAttendees.size(),'adHocAttendees size should equal to 2');
        
        controller.onSaveAttendees();
        //go back on the previous stage
        controller.movePreviousInWizard();
        controller.toStepAttendees();
        System.assertEquals(2,controller.state.adHocAttendees.size(),'adHocAttendees size should equal to 2');
        
        controller.index=0;
        controller.removeAdHocAttendee();
        System.assertEquals(1,controller.state.adHocAttendees.size(),'adHocAttendees size should equal to 1');
        
        controller.onSaveAttendees();
        
        
        
        test.stopTest();
    }         
    /**
*
@description TeststartCanvasFlow
*/ 
    public static testmethod void TeststartCanvasFlow(){
        //Create the sample Custom Setting Data
        bsource__BriefingSourceSettings__c bsource = new bsource__BriefingSourceSettings__c();
        bsource.bsource__API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        bsource.bsource__API_Password__c = 'test';
        bsource.bsource__API_Username__c = 'test@brieifingsource.com';
        bsource.bsource__IsCanvasApp__c = true;
        insert bsource;
        
        MockFactory mockData = new MockFactory();
        Opportunity opp = mockData.Opp;
        List < Contact > contacts = mockData.con;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        DSRCtrl controller = new DSRCtrl(sc);
        controller.state.dsr.Name = 'testDSR';
        
        Test.startTest();
        controller.startCanvasFlow();
        system.assertEquals([Select Id from BS_Deal_Support_Request__c].size(),1,'BS_Deal_Support_Request__c size should equal to 1');
        system.assertEquals(controller.renderCanvas,true,'renderCanvas  should equal to true');
      //  string appdomain = controller.getCanvasAppDomain();
       // system.assertEquals(appdomain,'sfdc','appdomain  should equal to sfdc');
     //   boolean isclassic = controller.getIsClassicWizard();
      //  system.assertEquals(isclassic,false,'isclassic  should equal to false');
        Test.stopTest();
        
    }
    /**
*
@description TeststartCanvasFlow2
*/
    public static testmethod void TeststartCanvasFlow2(){
        //Create the sample Custom Setting Data
        bsource__BriefingSourceSettings__c bsource = new bsource__BriefingSourceSettings__c();
        bsource.bsource__API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        bsource.bsource__API_Password__c = 'test';
        bsource.bsource__API_Username__c = 'test@brieifingsource.com';
        bsource.bsource__IsCanvasApp__c = true;
        insert bsource;
        
        MockFactory mockData = new MockFactory();
        Opportunity opp = mockData.Opp;
        List < Contact > contacts = mockData.con;
        
        ApexPages.CurrentPage().getparameters().put('id', opp.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        DSRCtrl controller = new DSRCtrl(sc);
        controller.state.dsr.Name = 'testDSR';
        controller.state.dsr.status__c='Submitted';
        
        Test.startTest();
        controller.startCanvasFlow();
        system.assertEquals([Select Id from BS_Deal_Support_Request__c].size(),1,'BS_Deal_Support_Request__c size should equal to 1');
        system.assertEquals(controller.renderCanvas,true,'renderCanvas  should equal to true');
     //   string appdomain = controller.getCanvasAppDomain();
     //   system.assertEquals(appdomain,'sfdc','appdomain size should equal to sfdc');
     //   boolean isclassic = controller.getIsClassicWizard();
     //   system.assertEquals(isclassic,false,'isclassic  should equal to false');
        Test.stopTest();
        
    }
    
}