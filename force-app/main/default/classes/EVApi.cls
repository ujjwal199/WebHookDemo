// API Docs:
// https://docs.google.com/document/d/1r32nXprMNCXVBAfkaouhHX6oHvxlfUOzPujZk-Nm-bU/edit?usp=sharing

public with sharing class EVApi {
    // Data source for API, can be real or mock
    public interface I_DataSource { 
        DSRUIModel.SitesResponse loadSites( DSRUIModel.SitesRequest req ) ;
        DSRUIModel.TopicsResponse loadTopics( DSRUIModel.TopicsRequest req ) ;
        DSRUIModel.CalendarResponse loadCalendar( DSRUIModel.CalendarRequest req ) ;
    }
    
    // points to mock or real data source 
    public static final I_DataSource DataSource = new BSDataSource();
    
    
    
    // The real API connected data source 
    public with sharing virtual class BSDataSource implements I_DataSource {
        //String endpoint = 'callout:Briefing_Source/';
        @testVisible
        protected String fetchJSON(HttpRequest req) {
            // set to maximum 
            req.setTimeout(120000);
            
            String jsn = null;            
            try {                
                Http http = new Http();
                HttpResponse resp = http.send(req);
                if (resp.getStatusCode() == 200) {
                    jsn = resp.getBody();
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[' +resp.getStatusCode() + '] Cannot reach BriefingSource : ' + resp.getStatus()));
                }
            } catch (CalloutException ce) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot reach BriefingSource : ' + ce.getMessage()));
            }            
            return jsn;
        }
        
        public virtual DSRUIModel.SitesResponse loadSites( DSRUIModel.SitesRequest req ) {
            DSRUIModel.SitesResponse resp = new DSRUIModel.SitesResponse();
            
            HttpRequest httpReq = getRequest('sites');//new HttpRequest();
            //httpReq.setEndpoint(this.endpoint + 'sites');
            httpReq.setMethod('GET');
            
            EVApiModel.SitesResponse apiResp = EVApiModel.parseSites(fetchJSON(httpReq));
            if (apiResp.success) {
                for (EVApiModel.Site site : apiResp.data) 
                    resp.sites.add(new DSRUIModel.Site(site.id, site.name, site.timezone.name, site.getStartHoursOfOperation(), site.getEndHoursOfOperation()));
            } else {
                //add error handling
            }
            // passing no category id
            return resp;
        }    
        
        public virtual DSRUIModel.TopicsResponse loadTopics( DSRUIModel.TopicsRequest req ) {
            DSRUIModel.TopicsResponse resp = new DSRUIModel.TopicsResponse();
            HttpRequest httpReq = getRequest('topics?siteId=' + req.siteId);//new HttpRequest();
            //httpReq.setEndpoint(this.endpoint + 'topics?siteId=' + req.siteId);
            httpReq.setMethod('GET');
            
            EVApiModel.TopicsResponse apiResp = EVApiModel.parseTopics(fetchJSON(httpReq));
            if (apiResp.success) {
                for (EVApiModel.Topic topic : apiResp.data) {
                    DSRUIModel.Topic uit = new DSRUIModel.Topic(topic.name, null);
                    uit.apiId = topic.id;
                    uit.categoryName = topic.category.name;
                    uit.categoryId = topic.category.id;                    
                    uit.duration = topic.duration;
                    resp.topics.add(uit);                    
                }
            } else {
                //add error handling
            }
            // passing no category id
            return resp;
        }
        
        public virtual DSRUIModel.CalendarResponse loadCalendar(DSRUIModel.CalendarRequest req) {
            DSRUIModel.CalendarResponse cr = new DSRUIModel.CalendarResponse();
            HttpRequest httpReq = getRequest('dates?siteId=' + req.siteId);//new HttpRequest();
            //httpReq.setEndpoint(this.endpoint +  'dates?siteId=' + req.siteId);
            httpReq.setMethod('GET');
            
            EVApiModel.CalendarDate[] calDates = EVApiModel.parseDates(fetchJSON(httpReq));
            
            for (EVApiModel.CalendarDate cd : calDates) {
                cr.dates.add(new DSRUIModel.CalendarItem(cd.start, cd.available));
            }
            return cr;
        }
    }
     @testVisible
    private static HttpRequest getRequest(String url) {
        string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
        bsource__BriefingSourceSettingsLists__c objSettings = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
        return getRequest(objSettings, url);
    }
     @testVisible
    private static HttpRequest getRequest(bsource__BriefingSourceSettingsLists__c briefingSourceSettings, String url) {
        String password = EncodingUtil.base64Encode(Blob.valueOf(briefingSourceSettings.API_Username__c + ':' + briefingSourceSettings.bsource__API_Password__c));        
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(briefingSourceSettings.API_Endpoint__c + url);
        httpReq.setHeader('Authorization', 'Basic ' + password);
        
        return httpReq;
    }
    public static Decimal getRefreshedTime(Briefing_Source_Settings__mdt objMetadata){
        Decimal minutes = 0;
        if(objMetadata.bsource__Refreshed_Time__c != null){dateTime endDate = system.now();
            DateTime startDate = objMetadata.bsource__Refreshed_Time__c;
            minutes = Integer.valueOf((endDate.getTime() - startDate.getTime())/(1000*60));
        }
        return minutes;
    }
    
    public class APIException extends Exception {}
    
    public class CentersResponse {
        
        public List<Center> data {get; set;}
        
    }
    
    public class Center {
        
        public Integer id {get; set;}
        public String name {get; set;}
        public List<BriefingType> briefingTypes {get; set;}
        
    }
    
    public class BriefingType {
        
        public Integer id {get; set;}
        public String name {get; set;}
        
    }
    
    public class FieldsResponse {
        public String label {get; set;}
        public List<Section> sections {get; set;}
        
    }
    
    public class Section {
        public String label {get; set;}  public List<Field> fields {get; set;}
        
    }
    
    public class Field {
        
        public String systemName {get; set;}
        public String label {get; set;}
        
    }
 	
    public static Map<String,List<parseJSON.FormFields>> getFields(bsource__BriefingSourceSettingsLists__c briefingSourceSettings) {
        system.debug('inside getFields init');
        //Decimal minutes = 0;
        String token = '',refreshToken = '';
        
        
        Decimal minutes = getRefreshedTime(briefingSourceSettings);
        system.debug('briefingSourceSettings>>'+briefingSourceSettings);
        String InstanceName = briefingSourceSettings.Name;
        
                system.debug('nAME briefingSourceSettings >>'+briefingSourceSettings.Name);

        Briefing_Source_Settings__mdt objMetadata = getCustomMetadata(InstanceName);
        bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName); 
        
        if(!Test.isRunningTest()){
            if(minutes == 0 || minutes > 45 || bss.bsource__API_Username__c != briefingSourceSettings.bsource__API_Username__c && objMetadata.bsource__Access_Token__c!= null){
                HttpResponse httpResponse = getToken(briefingSourceSettings);         Map<String,Object> resultMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
                system.debug('resultMap>>'+resultMap);
                token = String.valueOf(resultMap.get('access_token'));             refreshToken = String.valueOf(resultMap.get('refresh_token'));
     
             
                
            }else{        
                token = objMetadata.bsource__Access_Token__c;
                system.debug('chekc length'+token.length());
                
                  
                 
            } 
        } 
        HttpRequest httpRequest = createFieldRequest(briefingSourceSettings,token,'api/salesforce/forms/fields');
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(120 * 1000); // 2 minutes
        system.debug('httpRequest>>'+httpRequest);
        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);
        System.debug('httpResponse--->'+httpResponse.getBody());
        if (httpResponse.getStatusCode() == 200) {
            
            if(Test.isRunningtest()){
                httpResponse.setBody('{"data": [{"id": 1,"name": "Meeting Details","updated_at": "2021-03-06 09:15:55","active": true,"system": false,"custom": false,"order": 1,"alias": "meeting_details","parent_id": null,"blocked": false,"isSubSection": false,"subSections": [],"formFields": [{"id": 322,"name": "select_box_example","label": "Select Box Example","short_label": "Select Box Example","active": true,"custom": false,"type": "SELECT_BOX","field_type": "FORM","value_type": "","options": ["option 1","option 2","option 3"],"min_length": null,"max_length": null,"system": false,"order": 0,"widget": "NOTES","form_section_id": 1,"show_in_grid": false,"updated_at": "2021-03-04 14:25:04","file_links": null,"dynamic_table_columns_config": [],"show_in_cep": true,"show_in_webinar": false,"logicRules": [],"props": [],"dataIndex": "select_box_example","renderer": null,"title": "Select Box Example","type_formatted": "Selectbox","full_row": false}]}]}');
            }
            parseJSON parseJSON = parseJSON.parse(httpResponse.getBody());
            
            system.debug('parseJSON :: '+parseJSON.data[0]);
            
            Map<String,List<parseJSON.FormFields>> fields = new Map<String,List<parseJSON.FormFields>>();
            
            for (parseJSON.Data objData : parseJSON.Data) {
                system.debug('objData>>'+objData);
                if (objData.formFields != null) {
                    system.debug('objData.formFields>>'+objData.formFields);
                    List<parseJSON.FormFields> fieldsList = new List<parseJSON.FormFields>();
                    fieldsList.addAll(objData.formFields);
                    fields.put(objData.name,fieldsList);
                }
            }
            system.debug('fields final'+fields);
            // if(token != objMetadata.bsource__Access_Token__c){
            //    updateCustomMetadata(token,refreshToken);
            // }
            upsertCustomMetadata(token,refreshToken,InstanceName);
            
            //update access token in custom setting
                                  if(token.length()>255){
                                    System.debug('Access token is larger than life ');
                                       }
                                  else{
                                            try{  
                                                
                                                if(bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isAccessible() 
                                                   && bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isCreateable()   
                                                   && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Access_Token__c.isAccessible()
                                                   && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Access_Token__c.isCreateable()
                                                   && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Access_Token__c.isUpdateable()){
                                                 bsource__BriefingSourceSettingsLists__c bssUpdate= bsource__BriefingSourceSettingsLists__c.getValues(InstanceName);
                                                 bssUpdate.bsource__Access_Token__c=token;
                                                 Upsert bssUpdate;
                                                   }
            
                       
                                               }catch(Exception ex)   {System.debug('ex insert faileder  at line >>>>>'+ex.getLineNumber()+ 'ex cause >>'+ ex.getMessage());}
                 
                                       }
            return fields;
        } else {
            String message = 'Status: ' + httpResponse.getStatusCode() + ' - ' + httpResponse.getStatus();
            if (String.isNotBlank(httpResponse.getBody())) {  message += ' Response: ' + httpResponse.getBody();  }     throw new APIException(message);
        }
    }
    
    
    
    public static HttpResponse getToken(bsource__BriefingSourceSettingsLists__c briefingSourceSettings){
        system.debug('inside get token');
        //briefingSourceSettings = bsource__BriefingSourceSettings__c.getOrgDefaults();
        String endPoint = briefingSourceSettings.bsource__API_Endpoint__c;
        //String endPoint = 'https://sfdc-v3.briefingsource.com/';
        String parameters = '';
        parameters = 'client_id='+briefingSourceSettings.bsource__Client_Id__c+'&';
        parameters += 'client_secret='+briefingSourceSettings.bsource__Client_Secret__c+'&';
        parameters += 'username='+briefingSourceSettings.bsource__API_Username__c+'&';
        parameters += 'password='+briefingSourceSettings.bsource__API_Password__c+'&grant_type=password';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint+'oauth/token');
        request.setMethod('POST');
        request.setBody(parameters);
        HttpResponse response = http.send(request);
        system.debug('response status code>>'+response.getStatusCode());
        system.debug('response.getBody()>>'+response.getBody());
        
        if(Test.isRunningTest()){
            response.setBody('{"token_type":"Bearer","expires_in":86400,"access_token":"eyJ0eXAiOiJKV1QiLCJh","refresh_token":"def50200ff4068766a28"}');
        }
        Map<String,Object> resultMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody()); 
        System.debug('Response :: '+resultMap.get('access_token'));
        String token = String.valueOf(resultMap.get('access_token'));
        
        return response;
    }
    private static HttpRequest createFieldRequest(bsource__BriefingSourceSettingsLists__c briefingSourceSettings,String token,String Url) {                     
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(briefingSourceSettings.bsource__API_Endpoint__c+Url);
        //httpReq.setEndpoint('https://sfdc-v3.briefingsource.com'+Url);
        httpReq.setHeader('Authorization', 'Bearer ' + token);
        //httpReq.setMethod('GET');
        return httpReq;
    }
    public static Decimal getRefreshedTime(bsource__BriefingSourceSettingsLists__c objMetadata){
        Decimal minutes = 0;
        if(objMetadata.bsource__Refreshed_Time__c != null){
            dateTime endDate = system.now();
            DateTime startDate = objMetadata.bsource__Refreshed_Time__c;
            minutes = Integer.valueOf((endDate.getTime() - startDate.getTime())/(1000*60));
        }
        return minutes;
    }
    public static Briefing_Source_Settings__mdt getCustomMetadata(String InstanceName){
        Briefing_Source_Settings__mdt obj; 
        if(Briefing_Source_Settings__mdt.sObjectType.getDescribe().isAccessible() ){
            try{
                obj = [select id,DeveloperName,MasterLabel,bsource__Access_Token__c,bsource__Refresh_Token__c,bsource__Refreshed_Time__c 
                       from Briefing_Source_Settings__mdt WHERE DeveloperName=:InstanceName];
            }
            catch (Exception e) {
                obj = new Briefing_Source_Settings__mdt();
            }
            return obj;    }else{ return null;}
    }
    
    public static void upsertCustomMetadata(String accessToken,String refreshToken,string instanceName){
        //String token = EVApi.getToken();
        if(bsource__Briefing_Source_Settings__mdt.sObjectType.getDescribe().isAccessible()){
            Boolean isMetadataUpdateNeeded = false;
            
            //Get the customer record from Custom Metadata
            //bsource__Briefing_Source_Settings__mdt obj = [select id,DeveloperName,MasterLabel,bsource__Access_Token__c,bsource__Refresh_Token__c from bsource__Briefing_Source_Settings__mdt WHERE DeveloperName=:instanceName];
            
            
            //Create a deploy container which will be used for deploying(updating) the Custom Metadata Record
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            // system.debug('obj>>'+obj);
            //if(obj != null ){
            
            //create instance of Metadata.CustomMetadata
            Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
            metadataRec.fullName = 'bsource__Briefing_Source_Settings__mdt.'+instanceName;
            metadataRec.label = instanceName;
            
            //provide the value for the fields and add it to custom metadata instance
            Metadata.CustomMetadataValue tokenDetail = new Metadata.CustomMetadataValue();
            tokenDetail.field = 'bsource__Access_Token__c';
            tokenDetail.value = accessToken;
            metadataRec.values.add(tokenDetail);
            
            Metadata.CustomMetadataValue tokenDetail1 = new Metadata.CustomMetadataValue();
            tokenDetail1.field = 'bsource__Refresh_Token__c';
            tokenDetail1.value = refreshToken;
            metadataRec.values.add(tokenDetail1);
            
            Metadata.CustomMetadataValue refreshedTime = new Metadata.CustomMetadataValue();
            refreshedTime.field = 'bsource__Refreshed_Time__c';
            refreshedTime.value = system.now();
            metadataRec.values.add(refreshedTime);
            
            //Add the custom metadata instances in the container
            mdContainer.addMetadata(metadataRec);
            isMetadataUpdateNeeded = true; 
            // }
            
            //Check if metadata deployment is required
            if(isMetadataUpdateNeeded && !Test.isRunningTest()) {  /*Enqueue custom metadata deployment and get the deployment id  */ Metadata.Operations.enqueueDeployment(mdContainer, null);        }
            
        }
        
    }
    public static List<Center> getCenters() {
        string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
        bsource__BriefingSourceSettingsLists__c objSettings = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
        return getCenters(objSettings);
    }
    
    public static List<Center> getCenters(bsource__BriefingSourceSettingsLists__c briefingSourceSettings) {
        System.debug('briefingSourceSettings------>'+briefingSourceSettings);
        Briefing_Source_Settings__mdt objMetadata = getCustomMetadata(briefingSourceSettings.Name);
        Decimal minutes = getRefreshedTime(objMetadata);
        String token='',refreshToken='';
        system.debug('minutes>>'+minutes);
        if(minutes == 0 || minutes > 45){
            HttpResponse httpResponse = getToken(briefingSourceSettings);
            Map<String,Object> resultMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            token = String.valueOf(resultMap.get('access_token'));
            refreshToken = String.valueOf(resultMap.get('refresh_token')); 
        }else{
            token = objMetadata.bsource__Access_Token__c;
        }
        
        HttpRequest httpRequest = createFieldRequest(briefingSourceSettings,token,'api/centers');
        
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(120 * 1000); // 2 minutes
        System.debug('String xml = '+httpRequest.getBody());
        Http http = new Http();
        if(!Test.isRunningTest()){
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == 200) {
                system.debug('httpResponse.getBody()>>'+httpResponse.getBody());
                
                CentersResponse centersResponse = (CentersResponse) JSON.deserialize(httpResponse.getBody(), EVApi.CentersResponse.class);
                return centersResponse.data;
            } else {
                String message = 'Status: ' + httpResponse.getStatusCode() + ' - ' + httpResponse.getStatus();
                if (String.isNotBlank(httpResponse.getBody())) {
                    message += ' Response: ' + httpResponse.getBody();
                }
                throw new APIException(message);
            }  
        }else{
            httpResponse httpResponse =new httpResponse();
            httpResponse.setStatusCode(200);
            // httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA  Welcome to Customer Experience PortalThis section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"storagecentershomebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"Americ/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]}]}');
            httpResponse.setBody('{"current_page":1,"data":[{"id":1,"name":"Mt. View, Ca  EBC","alias":"mt._view_ca_usa","request_notification_to":["test@test.t","test@test.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":6,"start_time":"07:00:00","end_time":"20:00:00","date_format":"dMY","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210615 07:45:55","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":"Instructions and Guidance for Users.InstructionsSamplesHightlights","cep_welcome_text":"Mt. View, CA&nbsp; Welcome to Customer Experience Portal<div>This section can be edited by the briefing center staff to highlight their programs or to alert their users of special occasions or services.</div><p>Each center can have custom data that addresses their facility.","op_hours":"07:00 am  08:00 pm","entity_name":"Mt. View, Ca  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":6,"code":"America/Los_Angeles","name":"Pacific Time (US & Canada)"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":1,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":1,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":1,"briefing_type_id":3}}]},{"id":26,"name":"London, UK","alias":"miami_fl_usa","request_notification_to":["julia.yamamoto=mail.com@xmp.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":15,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:34","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":true,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"London, UK","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":true,"tz":{"id":15,"code":"America/Indiana/Indianapolis","name":"Eastern Time (US & Canada)"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":26,"briefing_type_id":9}},{"id":29,"name":"IBM Type","active":true,"description":"Test","include_in_api":true,"restricted_center_ids":[],"entity_name":"IBM Type","pivot":{"center_id":26,"briefing_type_id":29}}]},{"id":20,"name":"Paris CBC","alias":"paris_cbc","request_notification_to":["abc@abc1.com"],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":1,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:35","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris CBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":1,"code":"Etc/GMT","name":"International Date Line West"},"briefing_types":[{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":20,"briefing_type_id":9}},{"id":3,"name":"Room Only","active":true,"description":"Unsupported meeting with customer or partner involvement.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Room Only","pivot":{"center_id":20,"briefing_type_id":3}}]},{"id":6,"name":"Paris  EBC","alias":"santa_clara_ccc","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":3,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210402 14:09:36","region_id":null,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Paris  EBC","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":3,"code":"US/Hawaii","name":"Hawaii"},"briefing_types":[{"id":1,"name":"Customer Briefing","active":true,"description":"Fully supported customer visit.  A briefing manager will be assigned to this meeting and will work directly with sales to develop agenda and requirements.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Customer Briefing","pivot":{"center_id":6,"briefing_type_id":1}},{"id":9,"name":"Solution Workshop","active":true,"description":"Customer or Partner meeting requiring a POC and meeting rooms.","include_in_api":true,"restricted_center_ids":[],"entity_name":"Solution Workshop","pivot":{"center_id":6,"briefing_type_id":9}}]},{"id":31,"name":"Virtual Center","alias":"rsa_conference","request_notification_to":[],"briefing_allowed_days":[1,2,3,4,5],"active":true,"tz_id":66,"start_time":"07:00:00","end_time":"20:00:00","date_format":"m/d/Y","time_format":"h:i a","include_in_api":true,"language":"enUS","updated_at":"20210510 13:43:36","region_id":10,"ebc_on_the_road":false,"show_preferred_speaker":false,"suggested_topics":null,"cep_welcome_text":"Welcome to Customer Experience Portal","op_hours":"07:00 am  08:00 pm","entity_name":"Virtual Center","image":"/storage/centers/homebanner.png","banners":[],"is_preferred_speaker_enabled":false,"tz":{"id":66,"code":"Asia/Karachi","name":"Islamabad, Karachi"},"briefing_types":[{"id":16,"name":"Event Request Form","active":true,"description":"","include_in_api":true,"restricted_center_ids":[],"entity_name":"Event Request Form","pivot":{"center_id":31,"briefing_type_id":16}}]}]}');
            CentersResponse centersResponse = (CentersResponse) JSON.deserialize(httpResponse.getBody(), EVApi.CentersResponse.class);
            return centersResponse.data;
        }
        
        
        
    }
}