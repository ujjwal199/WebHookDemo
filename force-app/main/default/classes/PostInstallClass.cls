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
        List<bsource__BriefingSourceSettingsLists__c> BriefingSourceSettingList = bsource__BriefingSourceSettingsLists__c.getall().values();
        List<bsource__Show_Contact_Lists__c> showContactsList = bsource__Show_Contact_Lists__c.getall().values();
        List<bsource__Campaign_Ids_Lists__c> campaignIdsList = bsource__Campaign_Ids_Lists__c.getall().values();
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> BSFMappingList= bsource__Briefing_Source_Field_Mapping_Lists__c.getall().values();
        
        if(briefingSourceSettingsOldList.size()>0 && briefingSourceSettingsOldList!=null){
            if(bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isAccessible() 
               && bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isCreateable()   
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isCreateable()
              ){
                  if(BriefingSourceSettingList.size()==0){
                  bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsList = new bsource__BriefingSourceSettingsLists__c();
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
            if(Schema.sObjectType.bsource__Show_Contact_Lists__c.isAccessible()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.bsource__Show_Contact_Checkbox__c.isAccessible() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.bsource__Show_Contact_Checkbox__c.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.Name.isCreateable()){ 
                   if(showContactsList.size()==0){                   bsource__Show_Contact_Lists__c ShowContactList = new bsource__Show_Contact_Lists__c();                   ShowContactList.Name = instanceName;                   ShowContactList.bsource__Show_Contact_Checkbox__c = showContactOldList[0].bsource__Show_Contact_Checkbox__c;                   insert ShowContactList;
                   }
               }
        }
        if(campaignIdOldList.size()>0 && campaignIdOldList!=null){
            if(Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isAccessible() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isCreateable()){ 
                   if(campaignIdsList.size()==0){    bsource__Campaign_Ids_Lists__c CampaignIdList = new bsource__Campaign_Ids_Lists__c();      CampaignIdList.Name = instanceName;  CampaignIdList.bsource__Campaign_Id__c = campaignIdOldList[0].bsource__Campaign_Id__c;     insert CampaignIdList;
                   }
               }
        }
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> briefingSourceFieldMappingList = new List<bsource__Briefing_Source_Field_Mapping_Lists__c>();
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
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isUpdateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Briefing_Source_Field__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Salesforce_Field__c.isUpdateable()
          ){ 
              List<bsource__Briefing_Source_Field_Mapping__c> briefingSourceFieldMappingLists = new List<bsource__Briefing_Source_Field_Mapping__c>();
              briefingSourceFieldMappingLists =[Select bsource__Briefing_Source_Field__c,bsource__Salesforce_Field__c FROM bsource__Briefing_Source_Field_Mapping__c limit 49999];
              if(briefingSourceFieldMappingLists!=null){
                  for (Integer i = 0; i < briefingSourceFieldMappingLists.size(); i++) { 
                      bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping = new bsource__Briefing_Source_Field_Mapping_Lists__c();
                      if(BSFMappingList.size()==0){
                      briefingSourceFieldMapping.Name = instanceName + '_Mapping' + i;
                      briefingSourceFieldMapping.bsource__Briefing_Source_Field__c = briefingSourceFieldMappingLists[i].bsource__Briefing_Source_Field__c;
                      briefingSourceFieldMapping.bsource__Salesforce_Field__c = briefingSourceFieldMappingLists[i].bsource__Salesforce_Field__c;
                      briefingSourceFieldMapping.bsource__Instance_Name__c = instanceName;
                      briefingSourceFieldMappingList.add(briefingSourceFieldMapping);
                      }
                      
                  }
                  
                  if(!briefingSourceFieldMappingList.isempty()){ database.upsert(briefingSourceFieldMappingList,false); 
                  }
              }
          }
        //changes1
         List<bsource__BriefingSourceSettingsList__c> briefingSourceSettingsOldpublicList = [Select id,Name,bsource__API_Password__c,bsource__API_Username__c,bsource__Client_Id__c,
                                                                                  bsource__Client_Secret__c,bsource__isConnected__c,bsource__Refreshed_Time__c,
                                                                                  bsource__Refresh_Token__c,bsource__API_Endpoint__c from bsource__BriefingSourceSettingsList__c limit 49999];
       
        List<bsource__BriefingSourceSettingsLists__c> BriefingSourceSettingProtectedList = bsource__BriefingSourceSettingsLists__c.getall().values();
        List<bsource__Show_Contact_Lists__c> showContactsProtectedList = bsource__Show_Contact_Lists__c.getall().values();
        List<bsource__Campaign_Ids_Lists__c> campaignIdsProtectedList = bsource__Campaign_Ids_Lists__c.getall().values();
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> BSFMappingProtectedList= bsource__Briefing_Source_Field_Mapping_Lists__c.getall().values();
          
         if(briefingSourceSettingsOldpublicList.size()>0 && briefingSourceSettingsOldpublicList!=null){
            if(bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isAccessible() 
               && bsource__BriefingSourceSettingsLists__c.sObjectType.getDescribe().isCreateable()   
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Password__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Username__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Id__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Client_Secret__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Is_CanvasApp__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__isConnected__c.isCreateable()
               
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refreshed_Time__c.isCreateable()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isAccessible()
               && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__Refresh_Token__c.isCreateable()
              ){
                  if(BriefingSourceSettingProtectedList.size()==0){                  bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsPrivateLists = new bsource__BriefingSourceSettingsLists__c();                  BriefingSourceSettingsPrivateLists.Name= instanceName; BriefingSourceSettingsPrivateLists.bsource__API_Endpoint__c = briefingSourceSettingsOldpublicList[0].bsource__API_Endpoint__c;                  BriefingSourceSettingsPrivateLists.bsource__API_Password__c = briefingSourceSettingsOldpublicList[0].bsource__API_Password__c;                 BriefingSourceSettingsPrivateLists.bsource__API_Username__c = briefingSourceSettingsOldpublicList[0].bsource__API_Username__c;                  BriefingSourceSettingsPrivateLists.bsource__Client_Id__c = briefingSourceSettingsOldpublicList[0].bsource__Client_Id__c;               BriefingSourceSettingsPrivateLists.bsource__Client_Secret__c = briefingSourceSettingsOldpublicList[0].bsource__Client_Secret__c;                 BriefingSourceSettingsPrivateLists.bsource__Is_CanvasApp__c = briefingSourceSettingsOldpublicList[0].bsource__Is_CanvasApp__c;                  BriefingSourceSettingsPrivateLists.bsource__isConnected__c = briefingSourceSettingsOldpublicList[0].bsource__isConnected__c;                 BriefingSourceSettingsPrivateLists.bsource__Refreshed_Time__c = briefingSourceSettingsOldpublicList[0].bsource__Refreshed_Time__c;              BriefingSourceSettingsPrivateLists.bsource__Refresh_Token__c = briefingSourceSettingsOldpublicList[0].bsource__Refresh_Token__c;                Insert BriefingSourceSettingsPrivateLists;
                  }
              }
        }
        
        //change for 2
        List<bsource__Show_Contact_List__c> showContactOldPublicList  =  [Select id,Name,bsource__Show_Contact_Checkbox__c from  bsource__Show_Contact_List__c limit 49999];

         if(showContactOldPublicList.size()>0 &&  showContactOldPublicList!=null){
            if(Schema.sObjectType.bsource__Show_Contact_Lists__c.isAccessible()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.bsource__Show_Contact_Checkbox__c.isAccessible() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.bsource__Show_Contact_Checkbox__c.isCreateable() 
               && Schema.sObjectType.bsource__Show_Contact_Lists__c.fields.Name.isCreateable()){ 
                   if(showContactsList.size()==0){                   bsource__Show_Contact_Lists__c ShowContactList = new bsource__Show_Contact_Lists__c();                   ShowContactList.Name = instanceName;                   ShowContactList.bsource__Show_Contact_Checkbox__c = showContactOldPublicList[0].bsource__Show_Contact_Checkbox__c;                  insert ShowContactList;
                   }
               }
        }
        //change 3
               List<bsource__Campaign_Ids_List__c> campaignIdOldpublicList = [Select id,Name,bsource__Campaign_Id__c from  bsource__Campaign_Ids_List__c limit 49999];

         if(campaignIdOldpublicList.size()>0 && campaignIdOldpublicList!=null){
            if(Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isAccessible() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.bsource__Campaign_Id__c.isCreateable() 
               && Schema.sObjectType.bsource__Campaign_Ids_Lists__c.fields.Name.isCreateable()){ 
                   if(campaignIdsList.size()==0){                   bsource__Campaign_Ids_Lists__c CampaignIdProtectedList = new bsource__Campaign_Ids_Lists__c();                   CampaignIdProtectedList.Name = instanceName;                   CampaignIdProtectedList.bsource__Campaign_Id__c = campaignIdOldpublicList[0].bsource__Campaign_Id__c;                   insert CampaignIdProtectedList;
                   }
               }
        }
        //change 4
          List<bsource__Briefing_Source_Field_Mapping_Lists__c> briefingSourceFieldMappingProtectList = new List<bsource__Briefing_Source_Field_Mapping_Lists__c>();
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
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isUpdateable() 
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Briefing_Source_Field__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isUpdateable()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Salesforce_Field__c.isUpdateable()
          ){ 
              List<bsource__Briefing_Source_Field_Mapping_List__c> briefingSourceFieldMappingpublicLists = new List<bsource__Briefing_Source_Field_Mapping_List__c>();
              briefingSourceFieldMappingpublicLists =[Select bsource__Briefing_Source_Field__c,bsource__Salesforce_Field__c FROM bsource__Briefing_Source_Field_Mapping_List__c limit 49999];
              if(briefingSourceFieldMappingpublicLists!=null){
                  for (Integer i = 0; i < briefingSourceFieldMappingpublicLists.size(); i++) { 
                      bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping = new bsource__Briefing_Source_Field_Mapping_Lists__c();
                      if(BSFMappingList.size()==0){                      briefingSourceFieldMapping.Name = instanceName + '_Mapping' + i;                      briefingSourceFieldMapping.bsource__Briefing_Source_Field__c = briefingSourceFieldMappingpublicLists[i].bsource__Briefing_Source_Field__c;                 briefingSourceFieldMapping.bsource__Salesforce_Field__c = briefingSourceFieldMappingpublicLists[i].bsource__Salesforce_Field__c;                      briefingSourceFieldMapping.bsource__Instance_Name__c = instanceName;                     briefingSourceFieldMappingProtectList.add(briefingSourceFieldMapping);
                      }
                      
                  }
                  
                  if(!briefingSourceFieldMappingProtectList.isempty()){                      database.upsert(briefingSourceFieldMappingProtectList,false); 
                  }
              }
          }
        
        
        //Change 5 for meta data to protected custom settings
        
  Briefing_Source_Settings__mdt obj; 
        if(Briefing_Source_Settings__mdt.sObjectType.getDescribe().isAccessible() ){
            try{
             List<Briefing_Source_Settings__mdt>   objList = [select id,DeveloperName,MasterLabel,bsource__Access_Token__c,bsource__Refresh_Token__c,bsource__Refreshed_Time__c from Briefing_Source_Settings__mdt ];
              System.debug(objList);
                     Map<String,SObject> MtdList = new Map<String,SObject>();   
                for (  Briefing_Source_Settings__mdt DATA : objList) {
                      MtdList.put(DATA.DeveloperName,DATA);
                   }
                Set<String> InstanceNameMtds=MtdList.keySet();
                For(Sobject mtdData:MtdList.values()){
                    bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues( String.valueOf(mtdData.get('DeveloperName'))); 
                    String tokens = String.valueOf(mtdData.get('bsource__Access_Token__c'));
                    String RefreshTokens= String.valueOf(mtdData.get('bsource__refresh_token__c'));
                    if(bss != null){ 
                        bss.bsource__Access_Token__c = tokens;
                         bss.bsource__Refresh_Token__c=RefreshTokens;
                        Upsert bss;
                    }
                    
                    
                }
                
                
            }
            catch (Exception e) {
            System.debug('ex');
            }
         }
       
    }
}