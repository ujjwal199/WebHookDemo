@isTest
public class FetchDSRValuesTest {
    @TestSetup 
    static void testsetup(){
        Account acc = new Account();
        acc.Name = 'AccName';
        acc.BillingCity = 'BillingCity';
        acc.Type = 'test';
        acc.BillingStreet = 'BillingStreet';
        acc.BillingState = 'BillingState';
        acc.BillingPostalCode = 'BillingPostalCode';
        acc.BillingCountry = 'BillingCountry';
        acc.Phone = '1234567890';
        acc.Fax = '123456789';
        acc.AccountNumber = 'accnumber12345';
        acc.Website = 'www.test.com';
        acc.Industry = 'Test';
        acc.AnnualRevenue = 1.0;
        acc.NumberOfEmployees = 1;
        acc.Ownership = 'test';
        acc.TickerSymbol = 'test';
        acc.Description = 'testdescription';
        acc.Rating = 'good';
        acc.Site = 'www.test.com';
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
        oppty.Name='OppName';
        oppty.StageName='Qualification';
        oppty.accountId = acc.id;
        oppty.name = acc.Name;
        oppty.amount = 1.0;
        oppty.Description = 'test';
        //oppty.ExpectedRevenue = '';
        
        oppty.CloseDate=system.today();
        Insert oppty; 
        
        bsource__BS_Deal_Support_Request__c DSRobj=new bsource__BS_Deal_Support_Request__c();
        DSRobj.Name='DSRName';
        Insert DSRobj;
        
     /*   bsource__Deal_Support_Request_Relationship__c bDSRobj=new bsource__Deal_Support_Request_Relationship__c();
        bDSRobj.bsource__Account__c=acc.Id;
        bDSRobj.bsource__Campaign__c=camp.Id;
        bDSRobj.bsource__Contact__c=c.Id;
        bDSRobj.bsource__Opportunity__c=oppty.Id;
        bDSRobj.bsource__Deal_Support_Request__c=DSRobj.Id;
        insert bDSRobj;    */
    
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
    static void fetchDSRvaluesTest(){
        String dsrId=[select Id from bsource__BS_Deal_Support_Request__c].Id;
        String objectName='Account';
       //bsource__BS_Deal_Support_Request__c obj=[Select Id from bsource__BS_Deal_Support_Request__c where Name='DSRName'];  
       
       bsource__DSR_Account__c dsrRelationsListAccount = [SELECT Id,bsource__Account__c, bsource__Deal_Support_Request__c
                                                          FROM bsource__DSR_Account__c ];
         string JSONData= FetchDSRValues.fetchDSRvalues(dsrId,  objectName);
        system.debug(JSONData);
        system.assert(JSONData!=Null);
        
        }
    }