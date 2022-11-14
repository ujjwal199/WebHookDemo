global  class PostInstallClass implements InstallHandler{
    global  static string getInstanceName(String url){
        string sString = url;
        string[] splitted = sString.split('//');  
        Integer start = sString.IndexOf('://') + 3;
        Integer ends = sString.IndexOf('.');
        string finalstr = sString.mid(start,(ends-start));
        return finalstr;
    }
    
    
    global void onInstall(InstallContext context){
        List<bsource__BriefingSourceSettings__c> briefingSourceSettingsOldList = [Select id,Name,bsource__API_Password__c,bsource__API_Username__c,bsource__Client_Id__c,
                                                                                  bsource__Client_Secret__c,bsource__IsCanvasApp__c,bsource__isConnected__c,bsource__Refreshed_Time__c,
                                                                                  bsource__Refresh_Token__c,bsource__API_Endpoint__c from bsource__BriefingSourceSettings__c limit 49999];
        String instanceName;
        if(briefingSourceSettingsOldList.size()>0 && briefingSourceSettingsOldList!=null){
            instanceName = getInstanceName(briefingSourceSettingsOldList[0].bsource__API_Endpoint__c);
        }
        List<bsource__Campaign_Id__c> campaignIdOldList = [Select id,Name,bsource__Campaign_Id__c from  bsource__Campaign_Id__c limit 49999];
        List<bsource__Show_Contact__c> showContactOldList  =  [Select id,Name,bsource__Show_Contact_Checkbox__c from  bsource__Show_Contact__c limit 49999];
        List<bsource__BriefingSourceSettingsList__c> BriefingSourceSettingList = bsource__BriefingSourceSettingsList__c.getall().values();
        List<bsource__Show_Contact_List__c> showContactsList = bsource__Show_Contact_List__c.getall().values();
        List<bsource__Campaign_Ids_List__c> campaignIdsList = bsource__Campaign_Ids_List__c.getall().values();
        List<bsource__Briefing_Source_Field_Mapping_List__c> BSFMappingList= bsource__Briefing_Source_Field_Mapping_List__c.getall().values();
        
        if(briefingSourceSettingsOldList.size()>0 && briefingSourceSettingsOldList!=null){
            if(bsource__BriefingSourceSettingsList__c.sObjectType.getDescribe().isAccessible() 
               && bsource__BriefingSourceSettingsList__c.sObjectType.getDescribe().isCreateable()   
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.Name.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__API_Endpoint__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__API_Endpoint__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__API_Password__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__API_Password__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__API_Username__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__API_Username__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Client_Id__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Client_Id__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Client_Secret__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Client_Secret__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Is_CanvasApp__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Is_CanvasApp__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__isConnected__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__isConnected__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Refreshed_Time__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Refreshed_Time__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Refresh_Token__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsList__c.fields.bsource__Refresh_Token__c.isCreateable()
              ){
                  if(BriefingSourceSettingList.size()==0){
                  bsource__BriefingSourceSettingsList__c BriefingSourceSettingsList = new bsource__BriefingSourceSettingsList__c();
                  BriefingSourceSettingsList.Name= instanceName;
                  BriefingSourceSettingsList.bsource__API_Endpoint__c = briefingSourceSettingsOldList[0].bsource__API_Endpoint__c;
                  BriefingSourceSettingsList.bsource__API_Password__c = briefingSourceSettingsOldList[0].bsource__API_Password__c;
                  BriefingSourceSettingsList.bsource__API_Username__c = briefingSourceSettingsOldList[0].bsource__API_Username__c;
                  BriefingSourceSettingsList.bsource__Client_Id__c = briefingSourceSettingsOldList[0].bsource__Client_Id__c;
                  BriefingSourceSettingsList.bsource__Client_Secret__c = briefingSourceSettingsOldList[0].bsource__Client_Secret__c;
                  BriefingSourceSettingsList.bsource__Is_CanvasApp__c = briefingSourceSettingsOldList[0].bsource__IsCanvasApp__c;
                  BriefingSourceSettingsList.bsource__isConnected__c = briefingSourceSettingsOldList[0].bsource__isConnected__c;
                  BriefingSourceSettingsList.bsource__Refreshed_Time__c = briefingSourceSettingsOldList[0].bsource__Refreshed_Time__c;
                  BriefingSourceSettingsList.bsource__Refresh_Token__c = briefingSourceSettingsOldList[0].bsource__Refresh_Token__c;
                  Insert BriefingSourceSettingsList;
                  }
              }
        }
        if(showContactOldList.size()>0 &&  showContactOldList!=null){
            if(Schema.sObjectType.bsource__Show_Contact_List__c.isAccessible()
               && Schema.sObjectType.bsource__Show_Contact_List__c.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_List__c.fields.bsource__Show_Contact_Checkbox__c.isAccessible() 
               && Schema.sObjectType.bsource__Show_Contact_List__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Show_Contact_List__c.fields.bsource__Show_Contact_Checkbox__c.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_List__c.fields.Name.isCreateable()){ 
                   if(showContactsList.size()==0){
                   bsource__Show_Contact_List__c ShowContactList = new bsource__Show_Contact_List__c();
                   ShowContactList.Name = instanceName;
                   ShowContactList.bsource__Show_Contact_Checkbox__c = showContactOldList[0].bsource__Show_Contact_Checkbox__c;
                   insert ShowContactList;
                   }
               }
        }
        if(campaignIdOldList.size()>0 && campaignIdOldList!=null){
            if(Schema.sObjectType.bsource__Campaign_Ids_List__c.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_List__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_List__c.fields.bsource__Campaign_Id__c.isAccessible() 
               && Schema.sObjectType.bsource__Campaign_Ids_List__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_List__c.fields.bsource__Campaign_Id__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_List__c.fields.Name.isCreateable()){ 
                   if(campaignIdsList.size()==0){
                   bsource__Campaign_Ids_List__c CampaignIdList = new bsource__Campaign_Ids_List__c();
                   CampaignIdList.Name = instanceName;
                   CampaignIdList.bsource__Campaign_Id__c = campaignIdOldList[0].bsource__Campaign_Id__c;
                   insert CampaignIdList;
                   }
               }
        }
        List<bsource__Briefing_Source_Field_Mapping_List__c> briefingSourceFieldMappingList = new List<bsource__Briefing_Source_Field_Mapping_List__c>();
        if(bsource__Briefing_Source_Field_Mapping_List__c.sObjectType.getDescribe().isAccessible() 
           && bsource__Briefing_Source_Field_Mapping_List__c.sObjectType.getDescribe().isCreateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Salesforce_Field__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.Name.isCreateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Briefing_Source_Field__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Instance_Name__c.isCreateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Salesforce_Field__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.Name.isAccessible() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Briefing_Source_Field__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Instance_Name__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.Name.isUpdateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Briefing_Source_Field__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Instance_Name__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_List__c.fields.bsource__Salesforce_Field__c.isUpdateable()
          ){
              List<bsource__Briefing_Source_Field_Mapping__c> briefingSourceFieldMappingLists = new List<bsource__Briefing_Source_Field_Mapping__c>();
              briefingSourceFieldMappingLists =[Select bsource__Briefing_Source_Field__c,bsource__Salesforce_Field__c FROM bsource__Briefing_Source_Field_Mapping__c limit 49999];
              if(briefingSourceFieldMappingLists!=null){
                  for (Integer i = 0; i < briefingSourceFieldMappingLists.size(); i++) { 
                      bsource__Briefing_Source_Field_Mapping_List__c briefingSourceFieldMapping = new bsource__Briefing_Source_Field_Mapping_List__c();
                      if(BSFMappingList.size()==0){
                      briefingSourceFieldMapping.Name = instanceName + '_Mapping' + i;
                      briefingSourceFieldMapping.bsource__Briefing_Source_Field__c = briefingSourceFieldMappingLists[i].bsource__Briefing_Source_Field__c;
                      briefingSourceFieldMapping.bsource__Salesforce_Field__c = briefingSourceFieldMappingLists[i].bsource__Salesforce_Field__c;
                      briefingSourceFieldMapping.bsource__Instance_Name__c = instanceName;
                      briefingSourceFieldMappingList.add(briefingSourceFieldMapping);
                      }
                      
                  }
                  
                  if(!briefingSourceFieldMappingList.isempty()){
                      database.upsert(briefingSourceFieldMappingList,false); 
                  }
              }
          }
    }
}