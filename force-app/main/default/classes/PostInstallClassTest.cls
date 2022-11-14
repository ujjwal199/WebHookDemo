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
        
        bsource__Briefing_Source_Field_Mapping_Lists__c BriefingMap =  new bsource__Briefing_Source_Field_Mapping_Lists__c();
        BriefingMap.Name ='Test';
        BriefingMap.Briefing_Source_Field__c ='test';
        BriefingMap.Salesforce_Field__c = 'Test2';
        Insert  BriefingMap;
        
        /* Prev. active 
        bsource__BriefingSourceSettingsLists__c briefingSourceSettings = bsource__BriefingSourceSettingsLists__c.getOrgDefaults();
        briefingSourceSettings.API_Endpoint__c = 'https://sfdc.briefingsource.com/integration/api/';
        briefingSourceSettings.bsource__API_Username__c='https://sfdc.briefingsource.com';
        briefingSourceSettings.bsource__API_Password__c='test';
        briefingSourceSettings.bsource__Client_Id__c='test';
        briefingSourceSettings.bsource__Client_Secret__c='test';
        briefingSourceSettings.bsource__isConnected__c=true;
        briefingSourceSettings.Name ='test';
        briefingSourceSettings.bsource__Is_CanvasApp__c = true;
        insert briefingSourceSettings;
		*/
        
        bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
        objShowContacts.bsource__Show_Contact_Checkbox__c = false;
        objShowContacts.Name = 'test';
        insert objShowContacts;
        
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
        Test.testInstall(postinstall, null);
        system.assert(objShowContacts!=null, 'Is not null');
    }
}