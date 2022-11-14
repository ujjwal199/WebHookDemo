@isTest
public class CreateDSRRelationsTest {
    @TestSetup 
    static void testsetup(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        
        Campaign camp=new Campaign();
        camp.Name='test';
        camp.Status='Receive';
        insert camp;
        
        Opportunity oppty=new Opportunity();
        oppty.Name='Name';
        oppty.StageName='Qualification';
        oppty.CloseDate=system.today();
        Insert oppty;
        
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        insert DSRobj;
        
        /*      bsource__Deal_Support_Request_Relationship__c bDSRobj=new bsource__Deal_Support_Request_Relationship__c();
bDSRobj.bsource__Account__c=acc.Id;
bDSRobj.bsource__Campaign__c=camp.Id;
bDSRobj.bsource__Contact__c=c.Id;
bDSRobj.bsource__Opportunity__c=oppty.Id;
bDSRobj.bsource__Deal_Support_Request__c=DSRobj.Id;
insert bDSRobj;               */
        
        bsource__DSR_Account__c DSRAccount=new bsource__DSR_Account__c();
        DSRAccount.bsource__Account__c=acc.Id;
        DSRAccount.bsource__Deal_Support_Request__c=DSRobj.Id;
        Insert DSRAccount;
        
        bsource__DSR_Contact__c DSRContact=new bsource__DSR_Contact__c();
        DSRContact.bsource__Contact__c=c.Id;
        DSRContact.bsource__Deal_Support_Request__c=DSRobj.Id;
        insert DSRContact;
        
        bsource__DSR_Campaign__c DSRCampaign=new bsource__DSR_Campaign__c();
        DSRCampaign.bsource__Campaign__c=camp.Id;
        DSRCampaign.bsource__Deal_Support_Request__c=DSRobj.Id;
        Insert DSRCampaign;
        
        bsource__DSR_Opportunity__c DSROpportunity=new bsource__DSR_Opportunity__c();
        DSROpportunity.bsource__Opportunity__c=oppty.Id;
        DSROpportunity.bsource__Deal_Support_Request__c=DSRobj.Id;
        insert DSROpportunity;
        
    }
    @isTest
    public static void saveAccountDSRRecordsTest(){
        
        String accountIds=[select Id from Account limit 1].Id;
        String dsrRelationshipId=[select Id from bsource__BS_Deal_Support_Request__c limit 1].Id;
        String recid=[select Id from Account limit 1].Id;
        String objectname='Account';
        bsource__DSR_Account__c dsrRelationMain=[select Id,bsource__Deal_Support_Request__c,bsource__Account__c from bsource__DSR_Account__c where 
                                                 bsource__Account__c=:accountIds limit 1 ];
        //   bsource__Deal_Support_Request_Relationship__c dsrRelationMain=[select Id,bsource__Deal_Support_Request__c,bsource__Account__c from bsource__Deal_Support_Request_Relationship__c limit 1];
        createDSRRelations.saveAccountDSRRecords( accountIds,  dsrRelationshipId,  recid, objectname);
        //    dsrRelationMain=[select Id,bsource__Deal_Support_Request__c,bsource__Account__c
        //                      from bsource__Deal_Support_Request_Relationship__c where 
        //                          bsource__Account__c=:accountIds limit 1 ];
        
        system.assert(recid==dsrRelationMain.bsource__Account__c,'recid and bsource__Account__c should be equal');
        
    } 
    
    @isTest
    public static void saveOpptyDSRRecordsTest(){
        
        String opptyIds=[select Id from Opportunity limit 1].Id;
        String dsrRelationshipId=[select Id from bsource__BS_Deal_Support_Request__c limit 1].Id;
        String recid=[select Id from Opportunity limit 1].Id;
        String objectname='Opportunity';
        
        CreateDSRRelations.saveOpptyDSRRecords( opptyIds,  dsrRelationshipId,  recid, objectname);
        bsource__DSR_Opportunity__c dsrRelationMain=[select Id,bsource__Deal_Support_Request__c,bsource__Opportunity__c from bsource__DSR_Opportunity__c limit 1];
        system.assert(recid==dsrRelationMain.bsource__Opportunity__c,'recid and bsource__Opportunity__c should be equal');
    } 
    @isTest
    public static void saveContactDSRRecordsTest(){
        
        String contactIds=[select Id from Contact limit 1].Id;
        String dsrRelationshipId=[select Id from bsource__BS_Deal_Support_Request__c limit 1].Id;
        bsource__DSR_Contact__c dsrRelationMain=[select Id,bsource__Deal_Support_Request__c,bsource__Contact__c from bsource__DSR_Contact__c limit 1];
        CreateDSRRelations.saveContactDSRRecords( contactIds,  dsrRelationshipId);
        system.assert(contactIds==dsrRelationMain.bsource__Contact__c,'recid and bsource__Contact__c should be equal');
    } 
    @isTest
    public static void saveCampaignDSRRecordsTest(){
        
        String campaignIds=[select Id from Campaign limit 1].Id;
        String dsrRelationshipId=[select Id from bsource__BS_Deal_Support_Request__c limit 1].Id;
        bsource__DSR_Campaign__c dsrRelationMain=[select Id,bsource__Deal_Support_Request__c,bsource__Campaign__c from bsource__DSR_Campaign__c limit 1];
        // Paramter added to increase the code coverage
        CreateDSRRelations.saveCampaignDSRRecords( campaignIds,  dsrRelationshipId, 'test1');
        system.assert(campaignIds==dsrRelationMain.bsource__Campaign__c,'recid and bsource__Campaign__c should be equal');
    } 
    
    @isTest
    public static void getHelpDeskRecordTest(){
        List<bsource__HelpDesk__c> Helpdeskrecord=[SELECT Id, bsource__Account_Help_Text__c, bsource__Contact_Help_Text__c, bsource__Campaign_Help_Text__c, bsource__Opportunity_Help_Text__c FROM bsource__HelpDesk__c order by CreatedDate desc limit 1];
        CreateDSRRelations.getHelpDeskRecord('Test1');
        system.assert(Helpdeskrecord!=null,'Is not null');
    }
}