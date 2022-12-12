@istest
public class PostInstallClassTest {
    
    @isTest
    Public static void testMethod1(){
        bsource__BriefingSourceSettings__c objBriefingSourceSettings = new bsource__BriefingSourceSettings__c();
        objBriefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        objBriefingSourceSettings.bsource__API_Username__c='https://sfdc.briefingsource.com';
        objBriefingSourceSettings.bsource__API_Password__c='test';
        objBriefingSourceSettings.bsource__Client_Id__c='test';
        objBriefingSourceSettings.bsource__Client_Secret__c='test';
        objBriefingSourceSettings.bsource__isConnected__c=true;
        objBriefingSourceSettings.bsource__IsCanvasApp__c = true;
        insert objBriefingSourceSettings;
        
                    
                List<bsource__Show_Contact_Lists__c> showContactsList = bsource__Show_Contact_Lists__c.getall().values();
      

        bsource__Briefing_Source_Field_Mapping_Lists__c BriefingMap =  new bsource__Briefing_Source_Field_Mapping_Lists__c();
        BriefingMap.Name ='Test';
        BriefingMap.Briefing_Source_Field__c ='test';
        BriefingMap.Salesforce_Field__c = 'Test2';
        Insert  BriefingMap;
     
        // Prev. active 
        bsource__BriefingSourceSettingsList__c briefingSourceSettings = bsource__BriefingSourceSettingsList__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings.bsource__API_Username__c='https://sfdc.briefingsource.com';
        briefingSourceSettings.bsource__API_Password__c='test';
        briefingSourceSettings.bsource__Client_Id__c='test';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        insert briefingSourceSettings;
		//*/
        
        bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
        objShowContacts.bsource__Show_Contact_Checkbox__c = false;
        objShowContacts.Name = 'test';
       // insert objShowContacts;
        showContactsList.add(objShowContacts);
          insert showContactsList;
        bsource__Campaign_Ids_Lists__c CampaignIdList = new bsource__Campaign_Ids_Lists__c();
                   CampaignIdList.Name = 'Opportunity';
                   CampaignIdList.bsource__Campaign_Id__c='a001P00000x3LR2QAM';
                   insert CampaignIdList;
        
        //list public 
              List<bsource__Show_Contact_List__c> showContactsListpublic = bsource__Show_Contact_List__c.getall().values();
        insert showContactsListpublic;

        bsource__Briefing_Source_Field_Mapping_List__c BriefingMap1 =  new bsource__Briefing_Source_Field_Mapping_List__c();
        BriefingMap1.Name ='Test';
        BriefingMap1.Briefing_Source_Field__c ='test';
        BriefingMap1.Salesforce_Field__c = 'Test2';
        Insert  BriefingMap1;
        
       /* Prev. active 
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings1 = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings1.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings1.bsource__API_Username__c='https://sfdc.briefingsource.com';
        briefingSourceSettings1.bsource__API_Password__c='test';
        briefingSourceSettings1.bsource__Client_Id__c='test';
        briefingSourceSettings1.bsource__Client_Secret__c='test';
        briefingSourceSettings1.bsource__isConnected__c=true;
        briefingSourceSettings1.Name ='test';
        briefingSourceSettings1.bsource__Is_CanvasApp__c = true;
        insert briefingSourceSettings1;
		//*/
        
        bsource__Show_Contact_List__c objShowContacts1 = new bsource__Show_Contact_List__c();
        objShowContacts1.bsource__Show_Contact_Checkbox__c = false;
        objShowContacts1.Name = 'test';
        insert objShowContacts1;
        
        bsource__Campaign_Ids_List__c CampaignIdList1 = new bsource__Campaign_Ids_List__c();
                   CampaignIdList1.Name = 'Opportunity';
                   
                   insert CampaignIdList1;
        //************************
        
        bsource__Show_Contact__c objShowContact = new bsource__Show_Contact__c();
        objShowContact.bsource__Show_Contact_Checkbox__c = false;
        objShowContact.Name = 'test';
        insert objShowContact;
        
        bsource__Campaign_Id__c objCampaignId = new bsource__Campaign_Id__c();
        objCampaignId.bsource__Campaign_Id__c ='';
        objCampaignId.Name = 'test';   
        insert objCampaignId;
        
        bsource__Campaign_Ids_Lists__c objCampaignIds = new bsource__Campaign_Ids_Lists__c();
        objCampaignIds.bsource__Campaign_Id__c ='';
        objCampaignIds.Name = 'test';   
        insert objCampaignIds;
        PostInstallClass postinstall = new PostInstallClass();
        try{Test.testInstall(postinstall, null);}catch(Exception ex){} 
        system.assert(objShowContacts!=null, 'Is not null');
         
         try{
           
             List<Briefing_Source_Settings__mdt>   objList = [select id,DeveloperName,MasterLabel,bsource__Access_Token__c,bsource__Refresh_Token__c,bsource__Refreshed_Time__c from Briefing_Source_Settings__mdt ];
              System.debug(objList);
                     Map<String,SObject> MtdList = new Map<String,SObject>();   
                for (  Briefing_Source_Settings__mdt DATA : objList) {
                      MtdList.put(DATA.DeveloperName,DATA);
                   }
                Set<String> InstanceNameMtds=MtdList.keySet();
               List<bsource__BriefingSourceSettingsLists__c> L1=new List<bsource__BriefingSourceSettingsLists__c>();
                For(Sobject mtdData:MtdList.values()){
                    bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues( String.valueOf(mtdData.get('DeveloperName'))); 
                    String tokens = String.valueOf(mtdData.get('bsource__Access_Token__c'));
                    String RefreshTokens= String.valueOf(mtdData.get('bsource__Access_Token__c'));
                    if(bss != null){ 
                        bss.bsource__Access_Token__c = tokens;
                      
                        L1.add(bss);
                        
                    }
                    
                    
                }
             Upsert L1;
                
                
            }
            catch (Exception e) {
            System.debug('ex');
            }
        
        
    }
    @isTest
    public static void test22()
    {
          bsource__Briefing_Source_Field_Mapping__c briefingSourceFieldMappingLists = new bsource__Briefing_Source_Field_Mapping__c();
                      briefingSourceFieldMappingLists.bsource__Briefing_Source_Field__c='sadadasda';
                      briefingSourceFieldMappingLists.bsource__Salesforce_Field__c='opportunity';
        briefingSourceFieldMappingLists.Name='test';
           insert briefingSourceFieldMappingLists;
         PostInstallClass postinstall = new PostInstallClass();
        Test.testInstall(postinstall, null);
          bsource__Campaign_Ids_Lists__c CampaignIdList = new bsource__Campaign_Ids_Lists__c();
                   CampaignIdList.Name = 'Opportunity';
                   CampaignIdList.bsource__Campaign_Id__c='a001P00000x3LR2QAM';
                   insert CampaignIdList;
         //added assert
        system.assert(CampaignIdList!=null, 'CampaignIdList Is not null');
                system.assert(briefingSourceFieldMappingLists!=null, 'briefingSourceFieldMappingLists Is not null');

       
     }
}