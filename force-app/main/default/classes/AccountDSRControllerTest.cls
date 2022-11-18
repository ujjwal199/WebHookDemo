@isTest
private class AccountDSRControllerTest {

	static testmethod void testCreate1() {
		Account account = new Account();
		account.Name = 'Test';
		insert account;
        
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
        BS_Deal_Support_Request__c dsr = new BS_Deal_Support_Request__c();
        dsr.Status__c='Draft';
		insert dsr;
		EVApi.CentersResponse centersResponse = new EVApi.CentersResponse();
		centersResponse.data = new List<EVApi.Center>{center};

		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(200);
		httpResponse.setBody(JSON.serialize(centersResponse));
        
       // httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca - EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"d-M-Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-06-15 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.<ul>\t<li>Instructions</li>\t<li>Samples</li>\t<li>Hightlights</li></ul>","cep_welcome_text":"<h1>Mt. View, CA&nbsp;- Welcome to Customer Experience Portal</h1><div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.</p>","op_hours":"07:00 am - 08:00 pm","entity_name":"Mt. View, Ca - EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris - EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"Paris - EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-05-10 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]},{"id":34,"name":"EBC on the Road - Houston, TX","alias":"denver_co","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":9,"start_time":"08:00:00","end_time":"17:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:37","region_id":null,"ebc_on_the_road":true,"show_preferred_speaker":false,"suggested_topics":"","cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"08:00 am - 05:00 pm","entity_name":"EBC on the Road - Houston, TX","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":9,"code":"America/Boise","name":"Mountain Time (US & Canada)"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":34,"briefing_type_id":16}}]},{"id":36,"name":"EBC on the Road - Raleigh, NC","alias":"otr_orlando","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"08:00:00","end_time":"17:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:38","region_id":null,"ebc_on_the_road":true,"show_preferred_speaker":false,"suggested_topics":"","cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"08:00 am - 05:00 pm","entity_name":"EBC on the Road - Raleigh, NC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":36,"briefing_type_id":16}}]}],"first_page_url":"https://sfdc-v3.briefingsource.com/api/centers?page=1","from":1,"last_page":1,"last_page_url":"https://sfdc-v3.briefingsource.com/api/centers?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://sfdc-v3.briefingsource.com/api/centers?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"https://sfdc-v3.briefingsource.com/api/centers","per_page":50,"prev_page_url":null,"to":7,"total":7}');
        httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA&nbsp; Welcome to Customer Experience Portal<div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris  EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210510 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]}]}');
		ApexPages.currentPage().getParameters().put('accountId', account.Id);

		AccountDSRController controller = new AccountDSRController(new ApexPages.standardController(account));
        BS_Deal_Support_Request__c dsrs=new BS_Deal_Support_Request__c();
        insert dsrs;
                
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse,true));
        Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse,'Test'));
		//controller.changeCenter();
		//String aString = controller.canvasAppDomain;
		controller.initPage();
		//controller.save();
        controller.dsr=dsr;
       
        controller.cancelDSR();
         controller.dsr.bsource__Center__c=1;
       // controller.changeCenter();
       PageReference orderPage = new PageReference('/' +dsrs.Id );

		  controller.cancelDSR();
		System.assertEquals('Draft', controller.dsr.Status__c,'Draft Should be return');
		Test.stopTest();

		System.assertNotEquals(true, controller.canvasLocked,'canvasLocked Should be True');
	}
	
	static testmethod void testEdit() {
		Account account = new Account();
		account.Name = 'Test';
		insert account;
		
		BS_Deal_Support_Request__c dsr = new BS_Deal_Support_Request__c();
        dsr.bsource__Center__c=1;

		insert dsr;

		ApexPages.currentPage().getParameters().put('id', account.Id);
		//ApexPages.currentPage().getParameters().put('dsrId',dsr.Id);
        Test.startTest();
		AccountDSRController controller = new AccountDSRController(new ApexPages.standardController(account));
		controller.initPage();
        controller.dsr=dsr;
       
	    List<Account> accList = [select id, name from Account];
        system.assertEquals(accList.size()>0,True,'Size Should be Greater than 0');
        
        Test.stopTest();
        
    }
   
   static testmethod void testCreate4() {
		Account account = new Account();
		account.Name = 'Test';
		insert account;
        
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
        BS_Deal_Support_Request__c dsr = new BS_Deal_Support_Request__c();
        dsr.Status__c='Draft';
		insert dsr;
		EVApi.CentersResponse centersResponse = new EVApi.CentersResponse();
		centersResponse.data = new List<EVApi.Center>{center};

		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(200);
		httpResponse.setBody(JSON.serialize(centersResponse));
        
       // httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca - EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"d-M-Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-06-15 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.<ul>\t<li>Instructions</li>\t<li>Samples</li>\t<li>Hightlights</li></ul>","cep_welcome_text":"<h1>Mt. View, CA&nbsp;- Welcome to Customer Experience Portal</h1><div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.</p>","op_hours":"07:00 am - 08:00 pm","entity_name":"Mt. View, Ca - EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris - EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"Paris - EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-05-10 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am - 08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]},{"id":34,"name":"EBC on the Road - Houston, TX","alias":"denver_co","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":9,"start_time":"08:00:00","end_time":"17:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:37","region_id":null,"ebc_on_the_road":true,"show_preferred_speaker":false,"suggested_topics":"","cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"08:00 am - 05:00 pm","entity_name":"EBC on the Road - Houston, TX","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":9,"code":"America/Boise","name":"Mountain Time (US & Canada)"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":34,"briefing_type_id":16}}]},{"id":36,"name":"EBC on the Road - Raleigh, NC","alias":"otr_orlando","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"08:00:00","end_time":"17:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"en-US","updated_at":"2021-04-02 14:09:38","region_id":null,"ebc_on_the_road":true,"show_preferred_speaker":false,"suggested_topics":"","cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"08:00 am - 05:00 pm","entity_name":"EBC on the Road - Raleigh, NC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":36,"briefing_type_id":16}}]}],"first_page_url":"https://sfdc-v3.briefingsource.com/api/centers?page=1","from":1,"last_page":1,"last_page_url":"https://sfdc-v3.briefingsource.com/api/centers?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://sfdc-v3.briefingsource.com/api/centers?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"https://sfdc-v3.briefingsource.com/api/centers","per_page":50,"prev_page_url":null,"to":7,"total":7}');
        httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA&nbsp; Welcome to Customer Experience Portal<div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris  EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210510 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]}]}');
		ApexPages.currentPage().getParameters().put('accountId', account.Id);
		AccountDSRController controller = new AccountDSRController(new ApexPages.standardController(account));
		System.assertEquals('Draft', controller.dsr.Status__c,'Status__c Should be Draft');
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse,true));
        Test.setMock(HttpCalloutMock.class, new GenericCalloutMock(httpResponse,'Test'));
		//controller.changeCenter();
		controller.initPage();
		controller.save();
        controller.dsr=dsr;
        controller.cancelDSR();
       
		Test.stopTest();

		System.assertNotEquals(true, controller.canvasLocked,'canvasLocked Should be true');
	}
    static testmethod void testCreate5() {
		Account account = new Account();
		account.Name = 'Test';
		insert account;
        
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = '';
        briefingSourceSettings.bsource__API_Username__c='';
        briefingSourceSettings.bsource__API_Password__c='';
        briefingSourceSettings.bsource__Client_Id__c='';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        //briefingSourceSettings.Center__c ='test'
        insert briefingSourceSettings;
         bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        DSRobj.Center__c =2;
        insert DSRobj;
     	DSRController objDSRController= new DSRController();
        objDSRController.initPage();
        objDSRController.changeCenter();
		system.assert(DSRobj!=null, 'Inserted');
	}
    static testmethod void testCreate6() {
          string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
          Id dsrId = ApexPages.currentPage().getParameters().get('dsrId');
            Id accountId = ApexPages.currentPage().getParameters().get('accountId');
            Id opptyId = '0061P00000WwFMWQA3';
        bsource__BriefingSourceSettingsLists__c objSettings = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
           objSettings.bsource__API_Endpoint__c='';
                objSettings.bsource__API_Username__c='';
           objSettings.bsource__API_Password__c='';
           objSettings.bsource__Client_Id__c='';
        objSettings.bsource__Client_Secret__c='';
        DSRController objDSRController= new DSRController();
        objDSRController.initPage();
        objDSRController.changeCenter();
        
    }
    static testmethod void testCreate7() {
          string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
          Id dsrId = ApexPages.currentPage().getParameters().get('dsrId');
            Id accountId = ApexPages.currentPage().getParameters().get('accountId');
            Id opptyId = '0061P00000WwFMWQA3';
        bsource__BriefingSourceSettingsLists__c objSettings = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
          
        DSRController objDSRController= new DSRController();
       System.debug(objDSRController.centerOptions);
        
    }
      static testmethod void testCreate8() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
           System.debug(objDSRController.canChangeDsr);
                     System.debug(objDSRController.renderCanvas);
                     System.debug(objDSRController.canvasLocked);
            Test.stopTest();   
    }
    static testmethod void testCreate9() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
           System.debug(objDSRController.canvasInstanceName);
            Test.stopTest();   
    }
     static testmethod void testCreate10() {
          	Test.startTest();
            string instanceName= 'Account';
            bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getAll().get(instanceName);

           DSRController objDSRController= new DSRController();
           System.debug(objDSRController.canvasAppDomain);
            Test.stopTest();   
    }
    
    static testmethod void testCreate11() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
           System.debug(objDSRController.centerOptions);
            Test.stopTest();   
    }
    static testmethod void testCreate12() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
           System.debug(objDSRController.accObj);
            Test.stopTest();   
    }
    static testmethod void testCreate13() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
           System.debug(objDSRController.oppObj);
            Test.stopTest();   
    }
     static testmethod void testCreate14() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
          
           System.debug(objDSRController.canvasAppDomain);
            Test.stopTest();   
    }
     static testmethod void testCreate15() {
          	Test.startTest();
           DSRController objDSRController= new DSRController();
          bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = '';
        briefingSourceSettings.bsource__API_Username__c='';
        briefingSourceSettings.bsource__API_Password__c='';
        briefingSourceSettings.bsource__Client_Id__c='';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        //briefingSourceSettings.Center__c ='test'
        insert briefingSourceSettings;
       
            Test.stopTest();   
    }
       static testmethod void testCreate16() {
          	Test.startTest();
           BS_Deal_Support_Request__c dsr=new BS_Deal_Support_Request__c();
           dsr.bsource__Center__c=56789;
           insert dsr;
           DSRController objDSRController= new DSRController();
          objDSRController.save();
            Test.stopTest();   
    }
    
    
}