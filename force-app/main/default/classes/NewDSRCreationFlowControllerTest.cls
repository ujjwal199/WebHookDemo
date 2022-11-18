@isTest
public class NewDSRCreationFlowControllerTest {
    
    
    @isTest
    public static void getObjectName_Account(){
        Account acc = new Account();
        acc.Name = 'Name';
        insert acc;
        Id recId=acc.Id;
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
        Campaign c = new Campaign(Name='Test');
        insert c;
        
        bsource__Campaign_Ids_Lists__c objCampaignId = new bsource__Campaign_Ids_Lists__c();
        objCampaignId.bsource__Campaign_Id__c =c.Id;
        objCampaignId.Name = 'test';   
        insert objCampaignId;
        
        
        bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
        objShowContacts.bsource__Show_Contact_Checkbox__c = false;
        objShowContacts.Name = 'test';
        insert objShowContacts;
        
        //recId= 'a138E000000N9dr';
        Map<String,String> objectMap = NewDSRCreationFlowController.getObjectName(recId,'test');
        system.assert(objCampaignId!=null, 'Is not null');
        //  Account obj = [SELECT Id,Name from Account where Name = : objectMap.get('recordName')];
        // System.debug(' obj.Id ' +obj.Id);
        //  system.assert(obj.Id==recId,'Id and recId should be equal');
    }
    
    @isTest 
    public static void getObjectName_Opportunity(){
        
        Opportunity oppty=new Opportunity();
        oppty.Name='Name1';
        oppty.StageName='Qualification';
        oppty.CloseDate=system.today();
        Insert oppty;
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
        
        bsource__Campaign_Ids_Lists__c objCampaignId = new bsource__Campaign_Ids_Lists__c();
        objCampaignId.bsource__Campaign_Id__c ='';
        objCampaignId.Name = 'test';   
        insert objCampaignId;
        
        bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
        objShowContacts.bsource__Show_Contact_Checkbox__c = true;
        objShowContacts.Name = 'test';
        insert objShowContacts;
        Id recId=oppty.Id;
        // recId= 'a138E000000N9dr';
        System.debug(' recId ' +recId);
        Map<String,String> objectMap = NewDSRCreationFlowController.getObjectName(recId,'test');
        
        Opportunity oppt = [SELECT Id,Name from Opportunity where AccountId = : objectMap.get('accountId')];
        System.debug(' oppt.Id ' +oppt.Id);
        system.assert(oppt.Id==recId,'Id and recId should be equal');
        
    }
    @isTest
    public static void getObjectName_Null(){
        
        //recId= 'a138E000000N9dr';
        Map<String,String> objectMap = NewDSRCreationFlowController.getObjectName(null,'Test');
        
        
        system.assert(objectMap==Null,'objectMap should not be null');
    }
    
    @isTest
    public static void saveDSRObject_Account(){
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
        Campaign c = new Campaign(Name='Test');
        insert c;
        bsource__Campaign_Ids_Lists__c objCampaignId = new bsource__Campaign_Ids_Lists__c();
        objCampaignId.bsource__Campaign_Id__c ='';
        objCampaignId.Name = 'test';   
        insert objCampaignId;
        bsource__Campaign_Id__c customSettings = bsource__Campaign_Id__c.getOrgDefaults();
        customSettings.bsource__Campaign_Id__c=c.id;
        upsert customSettings;
        String nameDSR='NameDSR1';
        String objectName='Account';
        Id recId;
        
        Account acc1 = new Account();
        acc1.Name = 'Name';
        insert acc1;
        recId=acc1.Id; 
        
        Id NewId=NewDSRCreationFlowController.saveDSRObject(nameDSR,objectName,recId,'test');
        
        
        bsource__BS_Deal_Support_Request__c opptobj = [SELECT Id,Name,bsource__Account__c from bsource__BS_Deal_Support_Request__c where Id=:NewId];
        system.assert(recId==opptobj.bsource__Account__c,'recId should not be equal to bsource__Opportunity__c');
    }
    @isTest 
    public static void saveDSRObject_Opportunity(){
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
        Campaign c = new Campaign(Name='Test');
        insert c;
        bsource__Campaign_Ids_Lists__c objCampaignId = new bsource__Campaign_Ids_Lists__c();
        objCampaignId.bsource__Campaign_Id__c =c.Id;
        objCampaignId.Name = 'test';   
        insert objCampaignId;
        
        bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
        objShowContacts.bsource__Show_Contact_Checkbox__c = false;
        objShowContacts.Name = 'test';
        insert objShowContacts;
        
        String nameDSR='NameDSR1';
        String objectName='Opportunity';
        Id recId;
        
        Opportunity oppty1=new Opportunity();
        oppty1.Name='OppName';
        oppty1.StageName='Qualification';
        oppty1.CloseDate=system.today();
        Insert oppty1;
        recId=oppty1.Id;
        
        
        Id NewId=NewDSRCreationFlowController.saveDSRObject(nameDSR,objectName,recId,'test');
        
        bsource__BS_Deal_Support_Request__c opptobj = [SELECT Id,Name,bsource__Opportunity__c from bsource__BS_Deal_Support_Request__c where Id=:NewId];
        system.assert(recId==opptobj.bsource__Opportunity__c,'recId should not be equal to bsource__Opportunity__c');
    }
    @isTest 
    public static void getObjectName_BriefingSourceSettingsListNull(){
        
        Opportunity oppty=new Opportunity();
        oppty.Name='Name1';
        oppty.StageName='Qualification';
        oppty.CloseDate=system.today();
        Insert oppty;
        
        
        bsource__Campaign_Ids_Lists__c objCampaignId = new bsource__Campaign_Ids_Lists__c();
        objCampaignId.bsource__Campaign_Id__c ='';
        objCampaignId.Name = 'test';   
        insert objCampaignId;
        
        bsource__Show_Contact_Lists__c objShowContacts = new bsource__Show_Contact_Lists__c();
        objShowContacts.bsource__Show_Contact_Checkbox__c = true;
        objShowContacts.Name = 'test';
        insert objShowContacts;
        Id recId=oppty.Id;
        System.debug(' recId ' +recId);
        Map<String,String> objectMap = NewDSRCreationFlowController.getObjectName(recId,'test');
        
        Opportunity oppt = [SELECT Id,Name from Opportunity where AccountId = : objectMap.get('accountId')];
        System.debug(' oppt.Id ' +oppt.Id);
        system.assert(oppt.Id==recId,'Id and recId should be equal');
        
    }
    
    @isTest
    public static void showToastMsgTest(){
        String instanceName = apexpages.currentpage().getparameters().get('InstanceName');
        //bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsList = [Select id, bsource__API_Username__c, bsource__API_Password__c, bsource__Client_Id__c from bsource__BriefingSourceSettingsLists__c order by createddate desc limit 1 ]; 
         // Perform test below
        NewDSRCreationFlowController.showToastMsg();
        system.assert(instanceName !='', 'Record found');
       
    }
    
    @isTest
    public static void NewDSRCreationFlowController(){
        String instanceName = apexpages.currentpage().getparameters().get('InstanceName');
        //bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsList = [Select id, bsource__API_Username__c, bsource__API_Password__c, bsource__Client_Id__c from bsource__BriefingSourceSettingsLists__c order by createddate desc limit 1 ]; 
         // Perform test below
        NewDSRCreationFlowController newdsr= new NewDSRCreationFlowController();
        system.assert(instanceName !='', 'Record found');
       
    }
    
}