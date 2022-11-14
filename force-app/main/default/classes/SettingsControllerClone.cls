/*
API Url will be entered in one of two formats:

https://Brocade.briefingsource.com/
https://Brocade.briefingsource.com/index.php?r=
*/

//All the CheckAccessibility lines are commented for testing purposes.

global with sharing class SettingsControllerClone {
    
    /*private Set<String> excludeFields = new Set<String>{
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
    
    public String url {get; private set;}
    public String uname {get; set;}
    public Transient String passwd {get; set;}
    public String wizardType {get;set;}
    public String currentUser {get {return UserInfo.getUserName();} private set;}
    public List<Mapping> mappings {get; set;}
    public Map<String,List<Mapping>> mappingsMap {get; set;}
    public boolean isConnected {get;set;}
    public boolean disablePolar {get;set;}
    public String clientId {get; set;}
    public String clientSecret {get; set;}
    
    public SettingsControllerClone(){
        disablePolar = false;
        bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        if(bss != null && String.isNotEmpty(bss.API_Username__c) && String.isNotEmpty(bss.API_Username__c) && String.isNotEmpty(bss.API_Password__c)){
           isConnected = true;
        }else{
            isConnected = false;
        }
    }
    
    public void RefreshPage(){
        bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        system.debug('inside refresh bss>>'+bss.bsource__API_Username__c);
        uname = bss.bsource__API_Username__c;
        clientId = bss.bsource__Client_Id__c;
        clientSecret = bss.bsource__Client_Secret__c;
        disablePolar = false;
        isConnected = true;
    }
    public void onSave(){
        system.debug('uname>>'+uname);
        system.debug('passwd>>'+passwd);
        bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        system.debug('bss>>'+bss.bsource__API_Username__c);
        uname = bss.bsource__API_Username__c;
        isConnected = true;
        disablePolar = true;
        
    }
    public void initPage() {
        bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        if (bss != null && !String.isEmpty(bss.API_Endpoint__c)) {
            this.url = bss.API_Endpoint__c;//'https://' + bss.bsource__API_Endpoint__c.substringBetween('https://', 'integration/api/');
            system.debug('this.url'+this.url);
            this.uname = bss.API_Username__c;
            this.passwd = bss.API_Password__c;
            this.clientId = bss.bsource__Client_Id__c;
            this.clientSecret = bss.bsource__Client_Secret__c;
            if(bss.bsource__IsCanvasApp__c){
                this.wizardType = Label.WizardOption2;
            }else{
                this.wizardType = Label.WizardOption1;
            }
            
            try {
                /*String token = '';
                if(String.isBlank(bss.bsource__Access_Token__c)){
                    token = EVApi.getToken();
                }else{
                    token = bss.bsource__Access_Token__c;
                }*/
                /*fields = EVApi.getFieldsClone();
                
                loadBriefingSourceFieldMappings();
            } catch (Exception e) {
                system.debug('Excpetion>>'+e.getStackTraceString());
                system.debug('Excpetion>>'+e.getMessage()+' on line >>'+e.getLineNumber()+' cause>>'+e.getCause());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to load fields from API: ' + e.getMessage()+'  on line>>'+e.getLineNumber()));
            }
        }
    }
    
    public String getState() {
        Organization org = [SELECT Id, InstanceName, IsSandbox, OrganizationType, TrialExpirationDate FROM Organization LIMIT 1];
        
        String state    = 'sandbox=' + (org.IsSandbox);
        state           += '&orgId=' + UserInfo.getOrganizationId();
        
        return EncodingUtil.urlEncode(state, 'UTF-8');
    }
    
    public pagereference configureWizard(){
        bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        if (bss == null) {
            bss = new bsource__BriefingSourceSettings__c();
        }
        //if(CheckAccessibility.isUpsertable('bsource__IsCanvasApp__c','bsource__BriefingSourceSettings__c')) 
        //{ 
            if(wizardType == Label.WizardOption1){
                bss.bsource__IsCanvasApp__c = false;
            }else{
                bss.bsource__IsCanvasApp__c = true;
            }
            upsert bss;
        //}      
        return null;
    }
  
    public void Disconnected(){
        isConnected=false;
        
        uname = '';
    }
    
    
    public List<SelectOption> getWizardOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.WizardOption2,Label.WizardOption2));
        options.add(new SelectOption(Label.WizardOption1,Label.WizardOption1));
        return options;
    }
    
    public void saveMappings() {
        //if(CheckAccessibility.isDeletable('Briefing_Source_Field_Mapping__c'))
            delete [select Id from Briefing_Source_Field_Mapping__c LIMIT 9999];
        
        
        
        List<Briefing_Source_Field_Mapping__c> briefingSourceFieldMappings = new List<Briefing_Source_Field_Mapping__c>();
        
        Integer count = 0;
        system.debug('mappings in save'+mappings);
        system.debug('mappingsMap in save'+mappingsMap);
        //for (Mapping mapping : mappings) {
        for (String keyMapping : mappingsMap.keySet()) {
            for (Mapping mapping : mappingsMap.get(keyMapping)) {
                if (String.isNotBlank(mapping.opportunityFieldName)) {
                    count++;
                    
                    //system.debug('mapping.opportunityFieldName inside if'+mapping.opportunityFieldName);
                    Briefing_Source_Field_Mapping__c briefingSourceFieldMapping = new Briefing_Source_Field_Mapping__c();
                    
                    //if(CheckAccessibility.isUpsertable('Name,Briefing_Source_Field__c,Salesforce_Field__c','Briefing_Source_Field_Mapping__c'))
                    //{   
                        briefingSourceFieldMapping.Name = 'Mapping' + count;
                        briefingSourceFieldMapping.Briefing_Source_Field__c = mapping.field.name;
                        briefingSourceFieldMapping.Salesforce_Field__c = mapping.opportunityFieldName;
                        briefingSourceFieldMappings.add(briefingSourceFieldMapping);
                        //system.debug('briefingSourceFieldMapping insidee save'+briefingSourceFieldMapping);
                    //} 
                }
            }
        }
        system.debug('briefingSourceFieldMappings in save'+briefingSourceFieldMappings);
        if(!briefingSourceFieldMappings.isempty()){
            //if(CheckAccessibility.isUpsertable('Name','Briefing_Source_Field_Mapping__c'))
                database.upsert(briefingSourceFieldMappings,false); 
        }
        loadBriefingSourceFieldMappings();
    }
    
    public void restoreMappingDefaults() {
        //if(CheckAccessibility.isDeletable('Briefing_Source_Field_Mapping__c'))
            delete [select Id from Briefing_Source_Field_Mapping__c LIMIT 9999]; 
        
        List<Briefing_Source_Field_Mapping__c> briefingSourceFieldMappings = new List<Briefing_Source_Field_Mapping__c>();
        
        //List<Default_Briefing_Source_Field_Mapping__mdt> defaultBriefingSourceFieldMappings = [select Briefing_Source_Field__c, Salesforce_Field__c from Default_Briefing_Source_Field_Mapping__mdt];
        
        
        List<Default_Briefing_Source_Field_Mapping__mdt> defaultBriefingSourceFieldMappings = new List<Default_Briefing_Source_Field_Mapping__mdt> ();
       // String query = 'Select Id '+CheckAccessibility.isAccessible('Briefing_Source_Field__c, Salesforce_Field__c','Default_Briefing_Source_Field_Mapping__mdt')+' from Default_Briefing_Source_Field_Mapping__mdt LIMIT 49999';
         String query = 'Select Id, Briefing_Source_Field__c, Salesforce_Field__c from Default_Briefing_Source_Field_Mapping__mdt LIMIT 49999';
        system.debug('@@@@@@'+query);
        defaultBriefingSourceFieldMappings = database.query(query);
        
        
        for (Integer i = 0; i < defaultBriefingSourceFieldMappings.size(); i++) {
            Briefing_Source_Field_Mapping__c briefingSourceFieldMapping = new Briefing_Source_Field_Mapping__c();
            
            //if(CheckAccessibility.isUpsertable('Name,Briefing_Source_Field__c,Salesforce_Field__c','Briefing_Source_Field_Mapping__c'))
            //{
                briefingSourceFieldMapping.Name = 'Mapping' + (i + 1);
                briefingSourceFieldMapping.Briefing_Source_Field__c = defaultBriefingSourceFieldMappings[i].Briefing_Source_Field__c;
                briefingSourceFieldMapping.Salesforce_Field__c = defaultBriefingSourceFieldMappings[i].Salesforce_Field__c;
                briefingSourceFieldMappings.add(briefingSourceFieldMapping);
            //}
        }
        
        if(!briefingSourceFieldMappings.isempty()){
            //if(CheckAccessibility.isUpsertable('Name','Briefing_Source_Field_Mapping__c'))
                database.upsert(briefingSourceFieldMappings,false); 
        }
        
        loadBriefingSourceFieldMappings();
    }
    
    @RemoteAction    
    public static String setURL(String url, String username, String password,String cId,String cSecret) {
        String fullURL = url;
        
        bsource__BriefingSourceSettings__c bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        if (bss == null) {
            bss = new bsource__BriefingSourceSettings__c();
        }
        bss.API_Endpoint__c = fullURL;
        bss.API_Username__c = username;
        bss.API_Password__c = password;
        bss.IsCanvasApp__c = true;
        bss.bsource__Client_Id__c = cId;
        bss.bsource__Client_Secret__c = cSecret;
        if(String.isNotEmpty(bss.API_Username__c) && String.isNotEmpty(bss.API_Username__c) && String.isNotEmpty(bss.API_Password__c)){
            bss.bsource__isConnected__c = true;
        }
        
        try {
            system.debug('inside seturl try');
            EVApi.getFieldsClone(bss);
            system.debug('bss'+bss);
            upsert bss;
            return 'Success';
        } catch (Exception e) {
            system.debug('e'+e.getMessage() + 'on line>>'+e.getLineNumber());
            return e.getMessage() + '\n' + e.getStackTraceString();
        }
    }
    
    @RemoteAction
    global static List<Field> getFields(String name) {
        List<Field> fields = new List<Field>();
        fields.addAll(getFields('Opportunity', '', 'Opportunity - ', name));
        fields.addAll(getFields('Account', 'account.', 'Account - ', name));
        return fields;
    }
    
    private void loadBriefingSourceFieldMappings() {
        Map<String, Briefing_Source_Field_Mapping__c> briefingSourceFieldMappings = new Map<String, Briefing_Source_Field_Mapping__c>();
        
        for (Briefing_Source_Field_Mapping__c briefingSourceFieldMapping : [select Briefing_Source_Field__c, Salesforce_Field__c from Briefing_Source_Field_Mapping__c LIMIT 49999]) {
            briefingSourceFieldMappings.put(briefingSourceFieldMapping.Briefing_Source_Field__c, briefingSourceFieldMapping);
        }
        
        mappings = new List<Mapping>();
        mappingsMap = new Map<String,List<Mapping>>();
        system.debug('fields finalll'+fields);
        for(String eachSection :fields.keySet()){
            for(parseJSON.FormFields field:fields.get(eachSection)){
                Briefing_Source_Field_Mapping__c briefingSourceFieldMapping = briefingSourceFieldMappings.get(field.name);
                system.debug('briefingSourceFieldMapping>>'+briefingSourceFieldMapping);
                Mapping mapping = new Mapping();
                mapping.fieldLabel  = eachSection;
                mapping.display = !excludeFields.contains(field.name);
                mapping.field = field;
                
                if (briefingSourceFieldMapping != null) {
                    mapping.opportunityFieldName = briefingSourceFieldMapping.Salesforce_Field__c;
                    if (String.isNotBlank(mapping.opportunityFieldName)) {
                        mapping.opportunityFieldLabel = getLabel(mapping.opportunityFieldName);
                    }
                }
                mappings.add(mapping);
                if (mappingsMap.containsKey(mapping.fieldLabel)) {
                    mappingsMap.get(mapping.fieldLabel).add(mapping);
                } else {
                    mappingsMap.put(mapping.fieldLabel, new List<Mapping>{mapping});
                }
            }
        }
        system.debug('mappingsMap final'+mappingsMap);
        /*for (EVApi.Field field : fields) {
        Briefing_Source_Field_Mapping__c briefingSourceFieldMapping = briefingSourceFieldMappings.get(field.systemName);
        
        
        
        Mapping mapping = new Mapping();
        mapping.display = !excludeFields.contains(field.systemName);
        mapping.field = field;
        
        
        
        if (briefingSourceFieldMapping != null) {
        mapping.opportunityFieldName = briefingSourceFieldMapping.Salesforce_Field__c;
        if (String.isNotBlank(mapping.opportunityFieldName)) {
        mapping.opportunityFieldLabel = getLabel(mapping.opportunityFieldName);
        }
        }
        
        
        
        mappings.add(mapping);
        }*/
        /*system.debug('mappings'+mappings);
    }
    @testVisible
    private static String getLabel(String fieldName) {
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
    
    private static List<Field> getFields(String objectName, String valuePrefix, String labelPrefix, String query) {
        List<Field> fields = new List<Field>();
        
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        
        for (String fieldName : objectDescribe.fields.getMap().keySet()) {
            Schema.DescribeFieldResult fieldDescribe;
            
            if (objectDescribe.fields.getMap().containsKey(fieldName)) {
                fieldDescribe = objectDescribe.fields.getMap().get(fieldName).getDescribe();
            } else {
                fieldDescribe = objectDescribe.fields.getMap().get(Utils.namespace(fieldName)).getDescribe();
            }
            
            if (fieldDescribe.getLabel().toLowerCase().contains(query.toLowerCase())) {
                fields.add(new Field(valuePrefix + fieldDescribe.getName().toLowerCase(), labelPrefix + fieldDescribe.getLabel()));
            }
        }
        
        fields.sort();
        
        return fields;
    }
    
    
    global class Field implements Comparable {
        
        public String name {get; set;}
        public String label {get; set;}
        
        
        public Field(String name, String label) {
            this.name = name;
            this.label = label;
        }
        
        public Integer compareTo(Object otherObject) {
            Field otherField = (Field) otherObject;
            
            return label.compareTo(otherField.label);
        }
        
    }
    
    public class Mapping {
        
        public String fieldLabel {get; set;}
        public Boolean display {get; set;}
        public parseJSON.FormFields field {get; set;}
        public String opportunityFieldName {get; set;}
        public String opportunityFieldLabel {get; set;}
        
    }*/
    
}