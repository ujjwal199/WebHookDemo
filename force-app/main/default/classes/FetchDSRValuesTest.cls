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
        c.firstName='test';
      //   c.job_title='test';
         c.phone='test';
       // c.comments='test';
         c.Salutation='test';
        c.HomePhone='test';
         c.Department='test';
        
        c.MailingStreet='test';
         c.MailingCity='test';
        c.MailingState='test';
         c.MailingPostalCode='test';
        c.MailingCountry='test';
         c.Fax='test';
        c.AssistantName='test';
         c.LeadSource='test';

        insert c; 
        
        Campaign camp=new Campaign();
        camp.Name='test';
        camp.Status='Receive';
        camp.ExpectedRevenue=2313131.2;
        camp.BudgetedCost=2313131.2;
        camp.ActualCost=2313131.2;
        camp.Description='2313131';

        insert camp;
        
        Opportunity oppty=new Opportunity();
        oppty.Name='OppName';
        oppty.StageName='Qualification';
        oppty.accountId = acc.id;
        oppty.name = acc.Name;
        oppty.amount = 1.0;
        oppty.Description = 'test';
        oppty.TotalOpportunityQuantity = 21311.7;
        
        oppty.Type = 'test';
        oppty.NextStep = 'test';
        oppty.LeadSource = 'test';

        
        
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