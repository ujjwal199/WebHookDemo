/*
API Url will be entered in one of two formats:

https://Brocade.briefingsource.com/
https://Brocade.briefingsource.com/index.php?r=
*/

//All the CheckAccessibility lines are commented for testing purposes.
/**
* @description SettingsController
*/
global with sharing class SettingsController {
    
    private Set<String> excludeFields = new Set<String>{
        'account',
            'title',
            'requestor_name',
            'requestor_email',
            'requestor_phone',
            'preferred_date',
            'preferred_end_date',
            'preferred_start_time',
            'preferred_end_time',
            'alternate_date',
            'alternate_end_date',
            'alternate_start_time',
            'alternate_end_time'
            };
                
                private Map<String,List<parseJSON.FormFields>> fields;
    /**
* @description SettingsController
*/
    public String url {get;set;}
    // public String url {get;set;}
    /**
* @description uname
*/
    public String uname {get; set;}
    /**
* @description passwd
*/
    public Transient String passwd {get; set;}
    /**
* @description wizardType
*/
    public String wizardType {get;set;}
    /**
* @description currentUser
*/
    public String currentUser {get {return UserInfo.getUserName();} private set;}
    /**
* @description mappings
*/
    public List<Mapping> mappings {get; set;}
    /**
* @description objFieldMap
*/
    Public Set<string> objFieldMap{get;set;}
    /**
* @description mappingsMap
*/
    public Map<String,List<Mapping>> mappingsMap {get; set;}
    /**
* @description isConnected
*/
    public boolean isConnected {get;set;}
    /**
* @description disablePolar
*/
    public boolean disablePolar {get;set;}
    /**
* @description clientId
*/
    public String clientId {get; set;}  
    /**
* @description getMessageError
*/
    public String getMessageError {get;set;}
    /**
* @description clientSecret
*/
    public String clientSecret {get; set;}
    /**
* @description campaignIds
*/
    public string campaignIds{get;set;}
    /**
* @description HideContactCheckbox
*/
    public boolean showContactCheckbox{get;set;}
    /**
* @description SettingsController
*/
    public SettingsController(){}    public void initPage() {} 
    
    public pagereference configureWizard(){
        if(bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isAccessible() && bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isUpdateable()
           && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isUpdateable() 
           && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isCreateable()
          ){
              string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();         bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
              /*bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
if (bss == null) {
bss = new bsource__BriefingSourceSettings__c();
}*/
              //if(CheckAccessibility.isUpsertable('bsource__IsCanvasApp__c','bsource__BriefingSourceSettings__c')) 
              //{ 
              if(wizardType == Label.WizardOption1){  bss.bsource__Is_CanvasApp__c = false;   }else{  bss.bsource__Is_CanvasApp__c = true;  }  upsert bss;      }   return null;
    }
    
    public PageReference credentialPage(){   
        PageReference pageRef= new PageReference('/lightning/setup/NamedCredential/home');
        pageRef.setRedirect(true);
        Return null;
    }
    
    /**
* @description getWizardOptions
@return options
*/    
    public List<SelectOption> getWizardOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.WizardOption2,Label.WizardOption2));
        options.add(new SelectOption(Label.WizardOption1,Label.WizardOption1));
        return options;
    }
    
    //  Public set<string> objFieldMap
    /**
* @description errorMap
*/
    Public Map<string,string> errorMap ;
    /**
* @description getObjectFields
@param objectName
@return fields
*/
    @testVisible
    private static Set<string> getObjectFields(String objectName) {
        set<string> fields = new set<string>();
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        for (String fieldName : objectDescribe.fields.getMap().keySet()) {
            // fields.add('ObjectName  : '+objectName);
            fields.add((objectName+'.'+fieldName).toLowerCase());
        }
        system.debug('fieldsXYZ : '+fields);
        return fields;
    }
    
    @testVisible
    private static String getLabel(String fieldName) {
        String objectName = 'Opportunity';
        String labelPrefix = '';
        
        if (fieldName.contains('.')) {   objectName = 'Account';  labelPrefix = 'Account - ';  fieldName = fieldName.substringAfter('.');
        }
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(fieldName).getDescribe();
        
        return labelPrefix + fieldDescribe.getLabel();
    }
    /**
* @description getFields
@param objectName @param valuePrefix @param labelPrefix @param query
@return List
*/
    @testVisible
    private static List<Field> getFields(String objectName, String valuePrefix, String labelPrefix, String query) {
        List<Field> fields = new List<Field>();
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        for (String fieldName : objectDescribe.fields.getMap().keySet()) {
            Schema.DescribeFieldResult fieldDescribe;
            
            if (objectDescribe.fields.getMap().containsKey(fieldName)) {
                fieldDescribe = objectDescribe.fields.getMap().get(fieldName).getDescribe();    }   else {  fieldDescribe = objectDescribe.fields.getMap().get(Utils.namespace(fieldName)).getDescribe();
            }
            
            if (fieldDescribe.getLabel().toLowerCase().contains(query.toLowerCase())) {
                fields.add(new Field(valuePrefix + fieldDescribe.getName().toLowerCase(), labelPrefix + fieldDescribe.getLabel()));
            }
        }
        
        fields.sort();
        
        return fields;
    }
    global class Field implements Comparable {
        /**
* @description name
*/
        @AuraEnabled
        public String value {get; set;}
        /**
* @description label
*/
        @AuraEnabled
        public String label {get; set;}
        
        /**
* @description Field
*/
        
        public Field(String name, String label) {
            this.value = name;
            this.label = label;
        }
        /**
* @description compareTo
@param otherObject
@return Integer
*/
        public Integer compareTo(Object otherObject) {
            Field otherField = (Field) otherObject;
            
            return label.compareTo(otherField.label);
        }
        
    }
    /**
* @description Mapping
*/
    public class Mapping {
        /**
* @description fieldLabel
*/ 
        public String fieldLabel {get; set;}
        /**
* @description display
*/
        public Boolean display {get; set;}
        /**
* @description field
*/
        public parseJSON.FormFields field {get; set;}
        /**
* @description opportunityFieldName
*/
        public String opportunityFieldName {get; set;}
        /**
* @description opportunityFieldLabel
*/
        public String opportunityFieldLabel {get; set;}
        
    }
    
    @AuraEnabled  
    public static bsource__BriefingSourceSettingsLists__c saveBreifingSourceCredsSetting(String url, String username, String password,String cId,String cSecret,String briefingSourceInstanceName) {
        String fullURL = url;
        bsource__BriefingSourceSettingsLists__c bss = new bsource__BriefingSourceSettingsLists__c();
        bss.bsource__API_Endpoint__c = fullURL;
        bss.bsource__API_Username__c = username;
        bss.bsource__API_Password__c = password;
        bss.bsource__Is_CanvasApp__c = true;
        bss.bsource__Client_Id__c = cId;
        bss.bsource__Client_Secret__c = cSecret;
        bss.Name = briefingSourceInstanceName;
        bss.bsource__Refreshed_Time__c = system.now();
        if(String.isNotEmpty(bss.bsource__Client_Secret__c)  && String.isNotEmpty(bss.bsource__Client_Id__c)  && String.isNotEmpty(bss.API_Username__c) && String.isNotEmpty(bss.API_Endpoint__c) && String.isNotEmpty(bss.API_Password__c)){
            bss.bsource__isConnected__c = true;
        }
        string errorMessage = '';
        try {
            SettingsController.createRemoteSiteSetting(briefingSourceInstanceName,url);
            List<bsource__BriefingSourceSettingsLists__c>  BriefingSourceSettingsList = new  List<bsource__BriefingSourceSettingsLists__c>();
            if(Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isAccessible() 
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isAccessible()
               &&  Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isAccessible()){
                   BriefingSourceSettingsList = [SELECT Name,bsource__API_Endpoint__c FROM bsource__BriefingSourceSettingsLists__c WHERE Name =:briefingSourceInstanceName OR bsource__API_Endpoint__c =:fullURL];
               }
            if(BriefingSourceSettingsList.size()>0){   if(BriefingSourceSettingsList[0].bsource__API_Endpoint__c ==fullURL){  AuraHandledException objException= new AuraHandledException('Instance name is already exits');      objException.setMessage('BriefingSource API URL already exists');  throw objException;  
                }
                else if(BriefingSourceSettingsList[0].Name == briefingSourceInstanceName){   AuraHandledException objException= new AuraHandledException('Instance name is already exits');  objException.setMessage('Instance name is already exists');throw objException;
                }
            }
            try{
                if(!test.isRunningTest()){    EVApi.getFields(bss); }} catch (Exception e) {   AuraHandledException objException= new AuraHandledException('Failed to update the credentials');        objException.setMessage('Failed to update the credentials');         throw objException;
            }
            bsource__Custom_Toast_Messages__c objCustomToastMessages = bsource__Custom_Toast_Messages__c.getOrgDefaults();
            if(objCustomToastMessages!= null){
                if(objCustomToastMessages.bsource__Credentials_update_fail__c!=null){ errorMessage = objCustomToastMessages.bsource__Credentials_update_fail__c;   
                }
                else{
                    errorMessage = 'Failed to update the credentials';
                }
            }
            else{
                bsource__Custom_Toast_Messages__c objShowToast = new bsource__Custom_Toast_Messages__c();
                objShowToast.bsource__Credentials_update_fail__c = 'Failed to update the credentials';
                if(Schema.sObjectType.bsource__Custom_Toast_Messages__c.isAccessible() && Schema.sObjectType.bsource__Custom_Toast_Messages__c.isCreateable()){
                    insert objShowToast;
                }
                errorMessage = 'Failed to update the credentials';
            }
            if(Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isAccessible() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isUpdateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isCreateable()){
                   return bss; 
                   
               }
            AuraHandledException objException= new AuraHandledException('Failed to update the credentials');     objException.setMessage('Failed to update the credentials');  throw objException;
                    } catch (Exception e) {
            system.debug('e.getMessage()'+e.getMessage());
            system.debug('e.getMessage()'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    @AuraEnabled  
    public static void insertCustomSetting(String bssJSONString,String instanceName){
        bsource__BriefingSourceSettingsLists__c bss = (bsource__BriefingSourceSettingsLists__c)JSON.deserialize(bssJSONString, bsource__BriefingSourceSettingsLists__c.class);
        try{ 
            if(bss != null){
                System.debug(bss);
              if(Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isAccessible()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isUpdateable() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isCreateable()
                 
                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isAccessible()&& Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isCreateable()    && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isUpdateable()

               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isAccessible()     && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isCreateable()    && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isUpdateable()

               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isAccessible()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isCreateable()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isUpdateable()

                 
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isAccessible() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isCreateable()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isUpdateable()

               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isAccessible() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isCreateable() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isUpdateable()

               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isAccessible()   && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isCreateable() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isUpdateable()

               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isAccessible()&& Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isCreateable() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isUpdateable()

               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isAccessible()    && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isCreateable()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isUpdateable()

               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Briefing_Source_Instance_Name__c.isAccessible()    && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Briefing_Source_Instance_Name__c.isCreateable()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Briefing_Source_Instance_Name__c.isUpdateable()

               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isAccessible()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isCreateable()  && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isUpdateable()

               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isAccessible() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isCreateable() 
                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isUpdateable()){ 
                   
                    bsource__BriefingSourceSettingsLists__c bsc=new bsource__BriefingSourceSettingsLists__c();
                if(bss.bsource__API_Endpoint__c != null){
                      bsc.bsource__API_Endpoint__c=bss.bsource__API_Endpoint__c;
                }
                 if(bss.bsource__API_Password__c != null){
                      bsc.bsource__API_Password__c=bss.bsource__API_Password__c;
                }
                 if(bss.bsource__API_Username__c != null){
                      bsc.bsource__API_Username__c=bss.bsource__API_Username__c;
                }
                 if(bss.Name != null){
                      bsc.Name=bss.Name;
                     bsc.bsource__Briefing_Source_Instance_Name__c=bss.Name;

                }
                if(bss.bsource__isConnected__c != null){
                      bsc.bsource__isConnected__c=bss.bsource__isConnected__c;
                }
                 if(bss.bsource__Client_Id__c != null){
                      bsc.bsource__Client_Id__c=bss.bsource__Client_Id__c;
                }
                                 if(bss.bsource__Client_Secret__c != null){
                      bsc.bsource__Client_Secret__c=bss.bsource__Client_Secret__c;
                }
                    if(bss.bsource__Refreshed_Time__c != null){
                      bsc.bsource__Refreshed_Time__c=bss.bsource__Refreshed_Time__c;
                }
                    if(bss.bsource__Is_CanvasApp__c != null){
                      bsc.bsource__Is_CanvasApp__c=bss.bsource__Is_CanvasApp__c;
                }    
                upsert bsc;
                   
               }
                
                  
       }
            if(Schema.sObjectType.bsource__Show_Contact_Lists__c.isAccessible() && Schema.sObjectType.bsource__Show_Contact_Lists__c.isUpdateable()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.isCreateable()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.Name.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.bsource__Show_Contact_Checkbox__c.isCreateable()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.Name.isUpdateable() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.bsource__Show_Contact_Checkbox__c.isUpdateable()){ 
                   bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
                   objShowContacts.bsource__Show_Contact_Checkbox__c = false;
                   objShowContacts.Name = instanceName.escapeHtml4();
                   upsert objShowContacts;
               }
            if(Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isAccessible() && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isUpdateable()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isAccessible() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isCreateable()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isUpdateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isUpdateable()){ 
                   bsource__Campaign_Ids_Lists__c objCampaignId = new bsource__Campaign_Ids_Lists__c();
                   objCampaignId.bsource__Campaign_Id__c ='';
                   objCampaignId.Name = InstanceName;
                   
                   upsert objCampaignId;         }
}   catch (Exception e) {  throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static void Disconnected(String InstanceName){    
        system.debug('InstanceName'+InstanceName);
        bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName);
        if(Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isDeletable() ){
            Delete bss;  
        }
        bsource__Campaign_Ids_Lists__c CampaignIdList = bsource__Campaign_Ids_Lists__c.getValues(InstanceName);
        if(Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isDeletable() && CampaignIdList!= null){
            Delete CampaignIdList; 
        }
        bsource__Show_Contact_Lists__c ContactIdList = bsource__Show_Contact_Lists__c.getValues(InstanceName);
        if(Schema.sObjectType.bsource__Show_Contact_Lists__c.isDeletable() && ContactIdList!= null){
            Delete ContactIdList; 
        }
        
        if(Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.isDeletable()){
            Delete [Select Id, Briefing_Source_Field__c, Salesforce_Field__c from bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c=:InstanceName]; 
        }
        
        if(Schema.sObjectType.bsource__Default_Briefing_Source_Field_Mappings__c.isDeletable()){
            Delete [Select Id, Briefing_Source_Field__c, Salesforce_Field__c from bsource__Default_Briefing_Source_Field_Mappings__c WHERE bsource__Instance_Name__c=:InstanceName]; 
        }
        if(Schema.sObjectType.bsource__HelpDesk__c.isDeletable()){
            Delete [SELECT Id FROM bsource__HelpDesk__c where bsource__Instance_Name__c =:InstanceName];
        }
    } 
    @AuraEnabled
    public static briefingSourceInfoWrapper getBriefingSourceInfo(String InstanceName){
        bsource__BriefingSourceSettingsLists__c bss = new bsource__BriefingSourceSettingsLists__c();
        if(string.isNotBlank(InstanceName)){
            bss = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName);
        }
        bsource__Show_Contact_Lists__c showContact = bsource__Show_Contact_Lists__c.getValues(InstanceName);
        bsource__Campaign_Ids_Lists__c showCampaign= bsource__Campaign_Ids_Lists__c.getValues(InstanceName);
        briefingSourceInfoWrapper objbriefingSourceInfoWrapper = new briefingSourceInfoWrapper();
        objbriefingSourceInfoWrapper.BriefingSourceSettingsList = bss;
        objbriefingSourceInfoWrapper.CampaignIds = showCampaign;
        objbriefingSourceInfoWrapper.ShowContact = showContact;
        return objbriefingSourceInfoWrapper;
    }
    @AuraEnabled
    public static void saveContact(Boolean showContactCheckbox,String InstanceName){  
        bsource__Show_Contact_Lists__c objShowContact =bsource__Show_Contact_Lists__c.getValues(InstanceName);
        if(objShowContact!= null){
            objShowContact.bsource__Show_Contact_Checkbox__c =showContactCheckbox;
            if(Schema.sObjectType.bsource__Show_Contact_Lists__c.isAccessible() && Schema.sObjectType.bsource__Show_Contact_Lists__c.isUpdateable()){
                update objShowContact;
            }
        }
    }
    @AuraEnabled
    public Static String saveCampaigns(Boolean showCampaignCheckbox, String campaignIds,String InstanceName){  
        try{
            system.debug('showCampaignCheckbox'+showCampaignCheckbox);
            system.debug('campaignIds'+campaignIds);
            system.debug('InstanceName'+InstanceName);
            integer idCount = 0;
            boolean isValidId = false;
            String wrongId = '';
            Set<Id> CampaignIdSet = new Set<Id>();
            List<Id> checkCampaignIdAdmin = new List<Id>();
            if(campaignIds!= null){
                checkCampaignIdAdmin = campaignIds.split(',');
            }
            if(checkCampaignIdAdmin.size() > 0){
                if(Campaign.SObjectType.getDescribe().isAccessible() && Schema.sObjectType.Campaign.fields.Id.isAccessible()){
                    for(Campaign objCampaign : [select id from Campaign where id in : checkCampaignIdAdmin]){    CampaignIdSet.add(objCampaign.Id);
                    } 
                }
            }
            
            // Extra code added for Camapign Checkbox 28_06_2022
            /* bsource__Campaign_Ids_List__c objShowCampaign = bsource__Campaign_Ids_List__c.getValues(InstanceName);
if(objShowCampaign!= null){
objShowCampaign.bsource__Show_Campaign_Checkbox__c =showCampaignCheckbox;
if(Schema.sObjectType.bsource__Campaign_Ids_List__c.isAccessible() && Schema.sObjectType.bsource__Campaign_Ids_List__c.isUpdateable()){
update objShowCampaign;
}
}*/
            List<String> campaignIdAdmin= new List<String>();
            if(campaignIds!= null){
                campaignIdAdmin = campaignIds.split(',');  
            }
            for(String objId : campaignIdAdmin){
                if(objId.length() >14 && String.isNotBlank(objId) && CampaignIdSet.contains(objId)){  idCount += 1;
                }else{
                    System.debug('objId----->'+objId);
                    wrongId += objId+',';
                }
            }
            
            if(idCount == campaignIdAdmin.size()){    isValidId = true;
            }
            if(String.isNotBlank(campaignIds) && !isValidId && campaignIdAdmin.size() > 0){
                return 'Campaign ID entered is not valid. [ID] : ';
            }
            
            bsource__Campaign_Ids_Lists__c objCampaignIds =bsource__Campaign_Ids_Lists__c.getValues(InstanceName);
            if(String.isNotBlank(campaignIds) && isValidId){
                if(objCampaignIds!= null){
                    objCampaignIds.bsource__Campaign_Id__c =campaignIds;
                    objCampaignIds.bsource__Show_Campaign_Checkbox__c =showCampaignCheckbox;
                    if(Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isAccessible() && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isUpdateable()){
                        update objCampaignIds;
                    }
                }
            }
            else{
                objCampaignIds.bsource__Campaign_Id__c ='';
                objCampaignIds.bsource__Show_Campaign_Checkbox__c =showCampaignCheckbox;
                if(Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isAccessible() && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isUpdateable()){
                    update objCampaignIds;  
                }
            }
            return 'Success';
        }catch(exception e){
            System.debug('exception on line>>'+e.getLineNumber());
            System.debug('exception on line>>'+e.getStackTraceString());
            return 'Campaign ID entered is not valid.';
        }
    }
    
    @AuraEnabled
    public Static String getState() {
        Organization org;
        if(Schema.sObjectType.Organization.isAccessible()){
            org = [SELECT Id, InstanceName, IsSandbox, OrganizationType, TrialExpirationDate FROM Organization LIMIT 1];
        }
        String state    = 'sandbox=' + (org.IsSandbox);
        state           += '&orgId=' + UserInfo.getOrganizationId();
        
        return EncodingUtil.urlEncode(state, 'UTF-8');
    }
    
     @AuraEnabled
    public Static   void  setoauthuser(){
        String Username  =  UserInfo.getName();
        id profiles =  UserInfo.getProfileId();
          if(  Schema.sObjectType.Profile.isAccessible()
         
             && Schema.sObjectType.Profile.fields.Id.isAccessible()   
             && Schema.sObjectType.Profile.fields.Name.isAccessible() ){
                 System.debug('inside profile if');
                     list<Profile> l=[SELECT Id, Name FROM Profile where id=:profiles limit 1];
                 if(l.size() > 0){
                        System.debug('inside profile size profile>>'+l[0].Name);
                       String profileName= l[0].Name;
                                   if(Schema.sObjectType.bsource__OauthHandshakeUser__c.isCreateable() && Schema.sObjectType.bsource__OauthHandshakeUser__c.isAccessible()
                                      && Schema.sObjectType.bsource__OauthHandshakeUser__c.fields.bsource__profileName__c.isAccessible()
                                      && Schema.sObjectType.bsource__OauthHandshakeUser__c.fields.bsource__profileName__c.isCreateable()  
                                       && Schema.sObjectType.bsource__OauthHandshakeUser__c.fields.bsource__profileName__c.isUpdateable()
                                      && Schema.sObjectType.bsource__OauthHandshakeUser__c.fields.bsource__Username__c.isAccessible()  
                                      && Schema.sObjectType.bsource__OauthHandshakeUser__c.fields.bsource__Username__c.isCreateable() 
                                      && Schema.sObjectType.bsource__OauthHandshakeUser__c.fields.bsource__Username__c.isUpdateable()){
                                           System.debug('Username>>'+Username);
                                      //     bsource__OauthHandshakeUser__c bssOauth=new bsource__OauthHandshakeUser__c();
                                         //  bssOauth.bsource__profileName__c=profileName;
                                         //  bssOauth.bsource__Username__c=Username;
                                          try{
                                              List<bsource__OauthHandshakeUser__c> bssOauth =[Select id,bsource__profileName__c,bsource__Username__c From bsource__OauthHandshakeUser__c limit 1 ];
                                              if( bssOauth.size() > 0){
                                                   bssOauth[0].bsource__profileName__c=profileName;
                                                    bssOauth[0].bsource__Username__c=Username;
                                                    upsert bssOauth;  
                                                  System.debug('update successfully');
                                              }
                                              else{
                                                   bsource__OauthHandshakeUser__c bssOauth2=new bsource__OauthHandshakeUser__c();
                                                    bssOauth2.bsource__profileName__c=profileName;
                                                    bssOauth2.bsource__Username__c=Username;
                                                    upsert bssOauth2;
                                              } 
                                          }
                                          catch(exception ex) { 
                                             System.debug('update failed');
                                           
                                          }
        
                                      }
                 }
             }          
                     
           
    }
    
    @AuraEnabled
    public static String loadBriefingSourceFieldMapping(String InstanceName) {
        Map<String,List<Mapping>> mappingsMap = new Map<String,List<Mapping>>();
        if(string.isNotBlank(InstanceName)){  
            List<Mapping> mappings = new List<Mapping>();
            Set<String> excludeFields = new Set<String>{
                'account',
                    'title',
                    'requestor_name',
                    'requestor_email',
                    'requestor_phone',
                    'preferred_date',
                    'preferred_end_date',
                    'preferred_start_time',
                    'preferred_end_time',
                    'alternate_date',
                    'alternate_end_date',
                    'alternate_start_time',
                    'alternate_end_time'
                    };
                        
                        Map<String, bsource__Briefing_Source_Field_Mapping_Lists__c> briefingSourceFieldMappings = new Map<String, bsource__Briefing_Source_Field_Mapping_Lists__c>();
            if( bsource__Briefing_Source_Field_Mapping_Lists__c.SObjectType.getDescribe().isAccessible() &&
               Schema.SObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Briefing_Source_Field__c.isAccessible() &&
               Schema.SObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Salesforce_Field__c.isAccessible()){
                   for (bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping : [select Briefing_Source_Field__c, Salesforce_Field__c from bsource__Briefing_Source_Field_Mapping_Lists__c where bsource__Instance_Name__c =:instanceName LIMIT 49999]) {    briefingSourceFieldMappings.put(briefingSourceFieldMapping.Briefing_Source_Field__c, briefingSourceFieldMapping);
                   }  
               }
            //mappings = new List<Mapping>();
            bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName);
            Map<String,List<parseJSON.FormFields>> fields = new Map<String,List<parseJSON.FormFields>>();
            if(bss!= null){ fields = EVApi.getFields(bss);  
            }
            
            system.debug('fields finalll'+fields);
            for(String eachSection :fields.keySet()){    for(parseJSON.FormFields field:fields.get(eachSection)){
                    system.debug('field>>'+field);
                    system.debug('briefingSourceFieldMappings>>'+briefingSourceFieldMappings);  bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping = briefingSourceFieldMappings.get(field.name);
                    system.debug('briefingSourceFieldMapping>>'+briefingSourceFieldMapping);
                   Mapping mapping = new Mapping();                  mapping.fieldLabel  = eachSection;                  mapping.display = !excludeFields.contains(field.name);                mapping.field = field;
                    system.debug('briefingmapping>>'+eachSection);
                    
                    if (briefingSourceFieldMapping != null) { mapping.opportunityFieldName = briefingSourceFieldMapping.Salesforce_Field__c;                       if (String.isNotBlank(mapping.opportunityFieldName)) {   mapping.opportunityFieldLabel = getLabels(mapping.opportunityFieldName);
                        }
                    }
                    mappings.add(mapping);
                    if (mappingsMap.containsKey(mapping.fieldLabel)) {   mappingsMap.get(mapping.fieldLabel).add(mapping);  } else { mappingsMap.put(mapping.fieldLabel, new List<Mapping>{mapping});
                    }
                }
            }
            system.debug('mappingsMapmappingsMapmappingsMap'+mappingsMap);
        }
        return JSON.serialize(mappingsMap);
    }
    
    @AuraEnabled
    public static String getLabels(String fieldName) {
        String objectName = 'Opportunity';
        String labelPrefix = '';
        
        if (fieldName.contains('.')) {
            objectName = 'Account';
            labelPrefix = 'Account - ';
            fieldName = fieldName.substringAfter('.');
        }
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(fieldName).getDescribe();
        
        return labelPrefix + fieldDescribe.getLabel();
    }
    @AuraEnabled
    public static void saveBreifingSourceMapping(List<briefingSourceWrapper> briefingSourceFields,string instanceName) {
        if(bsource__Briefing_Source_Field_Mapping_Lists__c.sObjectType.getDescribe().isAccessible() 
           && bsource__Briefing_Source_Field_Mapping_Lists__c.sObjectType.getDescribe().isCreateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Salesforce_Field__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isCreateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Briefing_Source_Field__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Salesforce_Field__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isAccessible() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Briefing_Source_Field__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isAccessible()
          ){              
              system.debug('briefingSourceFields' + briefingSourceFields);
              List<bsource__Briefing_Source_Field_Mapping_Lists__c>  briefingSourceList = new List<bsource__Briefing_Source_Field_Mapping_Lists__c>();
              Integer briefingSourceFieldsCount =[SELECT COUNT() FROM bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c =:instanceName];
              Integer i = briefingSourceFieldsCount;
              
              for(briefingSourceWrapper objbriefingSourceWrapper : briefingSourceFields){
                  system.debug('objbriefingSourceWrapper.field' + objbriefingSourceWrapper.field);
                  bsource__Briefing_Source_Field_Mapping_Lists__c objbriefingSourceMapping = new  bsource__Briefing_Source_Field_Mapping_Lists__c();
                  objbriefingSourceMapping.bsource__Briefing_Source_Field__c = objbriefingSourceWrapper.key ;
                  objbriefingSourceMapping.bsource__Salesforce_Field__c = objbriefingSourceWrapper.field;
                  objbriefingSourceMapping.bsource__Instance_Name__c = instanceName.escapeHtml4();
                  objbriefingSourceMapping.Name = instanceName + '_Mapping' + i;
                  briefingSourceList.add(objbriefingSourceMapping);
                  i++;
              }
              insert briefingSourceList;
          }
    }
    @AuraEnabled
    global static List<Field> getFields(String instanceName) {
        List<Field> fields = new List<Field>();
        bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(instanceName.escapeHtml4());
        if(bss.bsource__isConnected__c){
            fields.addAll(getFields('Opportunity', '', 'Opportunity - ',''));
            fields.addAll(getFields('Account', 'account.', 'Account - ', ''));
        }
        return fields;
    }
    
    global class briefingSourceWrapper{
        @AuraEnabled
        public string field{get;set;}
        @AuraEnabled
        public string key{get;set;}
    }
    @AuraEnabled
    global static List<bsource__BriefingSourceSettingsList__c> getInstanceName() {
        return [SELECT Name FROM bsource__BriefingSourceSettingsList__c Where bsource__isConnected__c=true AND bsource__API_Username__c!=null 
                and bsource__API_Password__c!= null and bsource__API_Endpoint__c!= null and bsource__Client_Id__c != null 
                and bsource__Client_Secret__c!= null and Name!= null limit 49999];
    }
     @AuraEnabled
    global static List<bsource__BriefingSourceSettingsLists__c> getInstanceName2() {
        return [SELECT Name FROM bsource__BriefingSourceSettingsLists__c Where bsource__isConnected__c=true AND bsource__API_Username__c!=null 
                and bsource__API_Password__c!= null and bsource__API_Endpoint__c!= null and bsource__Client_Id__c != null 
                and bsource__Client_Secret__c!= null and Name!= null limit 49999];
    }
    global class briefingSourceInfoWrapper{
        @AuraEnabled
        public bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsList{get;set;}
        @AuraEnabled
        public bsource__Campaign_Ids_Lists__c CampaignIds{get;set;}
        @AuraEnabled
        public bsource__Show_Contact_Lists__c ShowContact{get;set;}
    }
    @AuraEnabled
    public static void restoreMappingDefaults(String instanceName) {
        System.debug('instanceName'+instanceName);
        if(bsource__Briefing_Source_Field_Mapping_Lists__c.sObjectType.getDescribe().isAccessible() && bsource__Briefing_Source_Field_Mapping_Lists__c.sObjectType.getDescribe().isCreateable() 
           && bsource__Briefing_Source_Field_Mapping_Lists__c.sObjectType.getDescribe().isDeletable()
           && bsource__Briefing_Source_Field_Mapping_Lists__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isUpdateable()  && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Salesforce_Field__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isUpdateable() && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Briefing_Source_Field__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Salesforce_Field__c.isCreateable() && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isCreateable() && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Briefing_Source_Field__c.isCreateable()
          ){  
              /* Prev. Below code is used for Restore and delete all purpose */
              delete [select Id from bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c=:instanceName]; 
              
              List<bsource__Briefing_Source_Field_Mapping_Lists__c> briefingSourceFieldMappings = new List<bsource__Briefing_Source_Field_Mapping_Lists__c>();
              
              List<bsource__Default_Briefing_Source_Field_Mappings__c> defaultBriefingSourceFieldMappings = new List<bsource__Default_Briefing_Source_Field_Mappings__c> ();
              defaultBriefingSourceFieldMappings = [Select Id, Briefing_Source_Field__c, Salesforce_Field__c from bsource__Default_Briefing_Source_Field_Mappings__c WHERE bsource__Instance_Name__c=:instanceName];
              
              
              for (Integer i = 0; i < defaultBriefingSourceFieldMappings.size(); i++) {     bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping = new bsource__Briefing_Source_Field_Mapping_Lists__c();
                  
                  
                  briefingSourceFieldMapping.Name = instanceName.escapeHtml4() + '_Mapping' + i;                  briefingSourceFieldMapping.Briefing_Source_Field__c = defaultBriefingSourceFieldMappings[i].Briefing_Source_Field__c;                  briefingSourceFieldMapping.Salesforce_Field__c = defaultBriefingSourceFieldMappings[i].Salesforce_Field__c;                  briefingSourceFieldMapping.bsource__Instance_Name__c = instanceName.escapeHtml4();                  briefingSourceFieldMappings.add(briefingSourceFieldMapping);
                  
              }
              
              if(!briefingSourceFieldMappings.isempty()){   database.upsert(briefingSourceFieldMappings,false); 
              }   
          }
    }
    public static void createRemoteSiteSetting(String instanceName,String url) {        
        MetadataService.MetadataPort service = createService();
        MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
        remoteSiteSettings.fullName = 'BreifingSource_'+instanceName.escapeHtml4();
        remoteSiteSettings.url = url;
        remoteSiteSettings.description='ewf';
        remoteSiteSettings.isActive=true;
        remoteSiteSettings.disableProtocolSecurity=false;
        MetadataService.AsyncResult[] results = service.create(new List<MetadataService.Metadata> { remoteSiteSettings });
        MetadataService.AsyncResult[] checkResults;
        if(!Test.isRunningTest()){       checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
        }
        // MetadataService.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
        system.debug( checkResults );  
        
    }
    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    @AuraEnabled
    public static string whiteListRemoteSiteSetting(){
        bsource__WhiteListRemoteSiteSetting__c bss = bsource__WhiteListRemoteSiteSetting__c.getOrgDefaults();
        if(bss != null && bss.bsource__Remote_site_setting_is_present__c == true){  return 'false'; 
        }
        else{
            URL baseUrl = URL.getSalesforceBaseUrl();
            if(baseUrl.getProtocol() == 'http'){ baseUrl = new URL('https', baseUrl.getHost(), baseUrl.getPort(), baseUrl.getFile()); } // Switch to https protocol
            return baseUrl.toExternalForm();            
        }
    }
    @AuraEnabled
    public static void updateRemoteSiteSetting(){
        if(bsource__WhiteListRemoteSiteSetting__c.sObjectType.getDescribe().isAccessible() && bsource__WhiteListRemoteSiteSetting__c.sObjectType.getDescribe().isUpdateable()
           && Schema.sObjectType.bsource__WhiteListRemoteSiteSetting__c.fields.bsource__Remote_site_setting_is_present__c.isUpdateable() 
           && Schema.sObjectType.bsource__WhiteListRemoteSiteSetting__c.fields.bsource__Remote_site_setting_is_present__c.isCreateable()
          ){
              bsource__WhiteListRemoteSiteSetting__c bss = bsource__WhiteListRemoteSiteSetting__c.getOrgDefaults();
              bss.bsource__Remote_site_setting_is_present__c = true;
              upsert bss;
          }
    }
    // @Deb
    // New method add to save Helpdesk data 27_06_2022
    @AuraEnabled
    public static string saveHelpDeskData(String inst, String acc, String con, String camp, String Opp){
        System.debug('Instance : '+inst);
        System.debug('account : '+acc);
        System.debug('contact : '+con);
        System.debug('campaign : '+camp);
        System.debug('opportunity : '+Opp);
        // Getting intance id from inst
        try { 
            List<bsource__HelpDesk__c> helpDeskList = [select Id from bsource__HelpDesk__c where bsource__Instance_Name__c =:inst limit 1];
            if(helpDeskList.size()>0){
                List<bsource__HelpDesk__c> updatedHelpDeskList = new List<bsource__HelpDesk__c>();
                For(HelpDesk__c objHelpDesk : helpDeskList){
                    objHelpDesk.bsource__Instance_Name__c = inst;
                    objHelpDesk.bsource__Account_Help_Text__c = acc;
                    objHelpDesk.bsource__Contact_Help_Text__c = con;
                    objHelpDesk.bsource__Campaign_Help_Text__c = camp;
                    objHelpDesk.bsource__Opportunity_Help_Text__c = Opp;
                    updatedHelpDeskList.add(objHelpDesk);
                }
                if(updatedHelpDeskList.size()>0 && Schema.sObjectType.bsource__HelpDesk__c.isAccessible() && Schema.sObjectType.bsource__HelpDesk__c.isUpdateable()){
                    update updatedHelpDeskList;
                }          
                return updatedHelpDeskList[0].id;
            }else{
                
                bsource__HelpDesk__c objhd = new bsource__HelpDesk__c();
                objhd.bsource__Instance_Name__c = inst;
                objhd.bsource__Account_Help_Text__c = acc;
                objhd.bsource__Contact_Help_Text__c = con;
                objhd.bsource__Campaign_Help_Text__c = camp;
                objhd.bsource__Opportunity_Help_Text__c = Opp;
                if(Schema.sObjectType.bsource__HelpDesk__c.isAccessible() && Schema.sObjectType.bsource__HelpDesk__c.isCreateable()){
                insert objhd;
                }
                return objhd.id;    }          }catch (Exception e) {       system.debug('g'+e.getLineNumber());        system.debug('g'+e.getMessage());     return e.getMessage();
        }
        
    }
    // New code for save HelpDesk data 
    
    // @Deb
    @AuraEnabled
    public static List<bsource__HelpDesk__c> getHelpDeskRecord(String instanceName) {
        System.debug('Records : '+[SELECT Id, bsource__Account_Help_Text__c, bsource__Contact_Help_Text__c, bsource__Campaign_Help_Text__c, bsource__Opportunity_Help_Text__c FROM bsource__HelpDesk__c WHERE bsource__Instance_Name__c =:instancename order by CreatedDate desc]);
        return [SELECT Id, bsource__Account_Help_Text__c, bsource__Contact_Help_Text__c, bsource__Campaign_Help_Text__c, bsource__Opportunity_Help_Text__c FROM bsource__HelpDesk__c WHERE bsource__Instance_Name__c =:instancename order by CreatedDate desc];
    }
    
    // @Deb 
	// for restoremapping 15_7_2022
	@AuraEnabled
    public static Boolean restoreobjectmapping(String instanceName){ 
        List<bsource__Default_Briefing_Source_Field_Mappings__c> restorevalue = [Select id, bsource__Instance_Name__c from bsource__Default_Briefing_Source_Field_Mappings__c where bsource__Instance_Name__c=:instanceName];
        if(restorevalue.size() > 0){         System.debug('Restoreobject value : '+ true);         return true;    } 
        else{      System.debug('Restoreobject value : '+ false);    
             return false;
    	}
    }
    
    @AuraEnabled
    public static void clearBriefingSourceMapping(String instanceName) {
        DELETE [SELECT ID FROM bsource__Default_Briefing_Source_Field_Mappings__c WHERE bsource__Instance_Name__c=:instanceName.escapeHtml4()];
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> briefingSourceFieldMappingsList = new List<bsource__Briefing_Source_Field_Mapping_Lists__c> ();
        List<bsource__Default_Briefing_Source_Field_Mappings__c> defaultBriefingSourceFieldMappingList = new List<bsource__Default_Briefing_Source_Field_Mappings__c>();
        briefingSourceFieldMappingsList = [Select Id, Briefing_Source_Field__c, Salesforce_Field__c from bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c=:instanceName];
        for (Integer i = 0; i < briefingSourceFieldMappingsList.size(); i++) {
            bsource__Default_Briefing_Source_Field_Mappings__c defaultBriefingSourceFieldMapping = new bsource__Default_Briefing_Source_Field_Mappings__c();
            
            
            defaultBriefingSourceFieldMapping.Name = instanceName.escapeHtml4() + '_Mapping' + i;
            defaultBriefingSourceFieldMapping.Briefing_Source_Field__c = briefingSourceFieldMappingsList[i].Briefing_Source_Field__c;
            defaultBriefingSourceFieldMapping.Salesforce_Field__c = briefingSourceFieldMappingsList[i].Salesforce_Field__c;
            defaultBriefingSourceFieldMapping.bsource__Instance_Name__c = instanceName.escapeHtml4();
            defaultBriefingSourceFieldMappingList.add(defaultBriefingSourceFieldMapping);
            
        }
        
        if(!defaultBriefingSourceFieldMappingList.isempty()){
            database.upsert(defaultBriefingSourceFieldMappingList,false); 
            database.delete(briefingSourceFieldMappingsList,false);
        }   
    }
    @AuraEnabled
    public static void resetPicklistValue(String instanceName,String picklistValue,string labelValue) {
        List<bsource__Briefing_Source_Field_Mapping_Lists__c>  briefingSourceFieldMappingsList =[Select Id, Briefing_Source_Field__c, Salesforce_Field__c 
                                                                                                FROM bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c=:instanceName
                                                                                                AND (Salesforce_Field__c=:picklistValue AND bsource__Briefing_Source_Field__c =: labelValue)];
        database.delete(briefingSourceFieldMappingsList,false);
        
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> updatedBriefingSourceFieldMappings = new List<bsource__Briefing_Source_Field_Mapping_Lists__c> ();
        updatedBriefingSourceFieldMappings = [Select Id, Briefing_Source_Field__c, Salesforce_Field__c from bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c=:instanceName];
        
        DELETE [Select Id, Briefing_Source_Field__c, Salesforce_Field__c from bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c=:instanceName];
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> briefingSourceFieldMappings = new List<bsource__Briefing_Source_Field_Mapping_Lists__c>();
        for (Integer i = 0; i < updatedBriefingSourceFieldMappings.size(); i++) {        bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping = new bsource__Briefing_Source_Field_Mapping_Lists__c();
            
            
            briefingSourceFieldMapping.Name = instanceName.escapeHtml4() + '_Mapping' + i;     briefingSourceFieldMapping.Briefing_Source_Field__c = updatedBriefingSourceFieldMappings[i].Briefing_Source_Field__c;         briefingSourceFieldMapping.Salesforce_Field__c = updatedBriefingSourceFieldMappings[i].Salesforce_Field__c;            briefingSourceFieldMapping.bsource__Instance_Name__c = instanceName.escapeHtml4();            briefingSourceFieldMappings.add(briefingSourceFieldMapping);
            
        }
        
        if(!briefingSourceFieldMappings.isempty())   {    database.upsert(briefingSourceFieldMappings,false);   }
        
    }
}