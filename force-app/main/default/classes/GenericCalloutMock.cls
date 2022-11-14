@isTest
public class GenericCalloutMock implements HttpCalloutMock, WebServiceMock {
	
	@TestVisible
	private List<HttpResponse> httpResponses = new List<HttpResponse>();
	private List<Object> webServiceResponses = new List<Object>();

	@TestVisible
	private Integer httpResponseIndex = 0;
	private Integer webServiceResponseIndex = 0;


	public GenericCalloutMock() {}

	public GenericCalloutMock(HttpResponse httpResponse) {
		httpResponses.add(httpResponse);
	}
	public GenericCalloutMock(HttpResponse httpResponse,string name) {
		httpResponses.add(httpResponse);
	}
    public GenericCalloutMock(HttpResponse httpResponse,boolean iscall) {
		httpResponses.add(httpResponse);
	}
	public GenericCalloutMock(List<HttpResponse> httpResponses) {
		this.httpResponses.addAll(httpResponses);
	}
	
	public GenericCalloutMock(String staticResourceName) {
		this(new List<String>{staticResourceName});
	}
	
	public GenericCalloutMock(List<String> staticResourceNames) {
		Map<String, StaticResource> staticResources = new Map<String, StaticResource>();
		
		for (StaticResource staticResource : [select Name, Body from StaticResource where Name in :staticResourceNames]) {
			staticResources.put(staticResource.Name, staticResource);
		}

		for (String staticResourceName : staticResourceNames) {
			HttpResponse httpResponse = new HttpResponse();
			httpResponse.setBodyAsBlob(staticResources.get(staticResourceName).Body);
			httpResponses.add(httpResponse);
		}
	}
	
	public GenericCalloutMock(Object webServiceResponse) {
		webServiceResponses.add(webServiceResponse);
	}
	
	public void addWebServiceResponse(Object webServiceResponse) {
		webServiceResponses.add(webServiceResponse);
	}


	// -------------------------------------------------------------------
	// HttpCalloutMock implementation.
	// -------------------------------------------------------------------
	
	public HTTPResponse respond(HTTPRequest request) {
      	return httpResponses[httpResponseIndex++];
		//return httpResponse;
	}
    public HTTPResponse respond(HTTPRequest request,String name) {
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
		httpResponse.setBody(JSON.serialize('{"token_type":"Bearer","expires_in":86400,"access_token":"eyJ0eXAiOiJKV1QiLCJh","refresh_token":"def50200ff4068766a28"}'));
		return httpResponse;
	}
    
     public HTTPResponse respond1(HTTPRequest request,boolean iscall) {
        System.debug('request---->');
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200); //oauth/token
        httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA&nbsp; Welcome to Customer Experience Portal<div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris  EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210510 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]}]}');

		return httpResponse;
	}
	// -------------------------------------------------------------------
	// WebServiceMock implementation.
	// -------------------------------------------------------------------
	
	public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
		Object webServiceResponse = webServiceResponses[webServiceResponseIndex++];
		response.put('response_x', webServiceResponse);
	}
	
}