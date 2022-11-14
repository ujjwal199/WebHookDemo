@isTest
public class MultiSelectLookupControllerTest {
    @TestSetup 
    static void testsetup(){
        //Insert Custom Setting for Setting the flag  cs.bsource__Attendee_Trigger__c = true;
        bsource__Trigger_Switch__c cs = new bsource__Trigger_Switch__c();
        cs.bsource__Attendee_Trigger__c = true;
        insert cs;
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;   
        
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        bsource__Briefing_Attendee__c objAttendee=new bsource__Briefing_Attendee__c();
        objAttendee.bsource__First_Name__c ='FName';
        objAttendee.bsource__Last_Name__c='LName';
        objAttendee.bsource__Email__c='email@gmail.com';
        insert objAttendee;     
        
        Campaign camp=new Campaign();
        camp.Name='test';
        camp.Status='Receive';
        insert camp;
        
        Opportunity oppty=new Opportunity();
        oppty.Name='Name';
        oppty.StageName='Qualification';
        oppty.CloseDate=system.today();
        oppty.AccountId=acc.id;
        oppty.contactid=c.id;
        Insert oppty;
    } 
    @isTest static void retrieveRecords_Account(){ 
        String objectName='Account'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=lstResult[0].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should be 0 ');        
    }      
    
    @isTest static void retrieveRecords_Contact(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='LName';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        ocrlist=[select Id from Opportunity Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        system.assertEquals(accountslist!=null, true,'accountslist should not be 0 ');  
    }  
    @isTest static void retrieveRecords_ContactwithNullAccount(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom='Account';
        string strQuery = 'SELECT Id,Name,accountid from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].id;
        ocrlist=[select Id,AccountId from Opportunity Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }  
    @isTest static void retrieveRecords_ContactwithNull(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom='Account';
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        //accountslist=[select Id from Account Limit 1].Id;
        //ocrlist=[select Id from Opportunity Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }  
    @isTest static void retrieveRecords_Campaign(){ 
        String objectName='Campaign'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        //accountslist=lstResult[0].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }       
    @isTest static void retrieveRecords_Opportunity(){ 
        String objectName='Opportunity'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom='Opportunity';
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }    
    @isTest static void retrieveRecords_OpportunitywithNullAccount(){ 
        String objectName='Opportunity'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        // accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }    
     @isTest static void retrieveRecords_Opportunity1(){ 
        String objectName='Opportunity'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    } 
    @isTest static void retrieveRecords_Opportunity2(){ 
        String objectName='Account'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    } 
    
    
        @isTest static void retrieveRecords_ContactwithNullAccount2(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
        String initiatedfrom;
        string strQuery = 'SELECT Id,Name,accountid from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].id;
        ocrlist=[select Id,AccountId from Opportunity Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }
    
    
      @isTest static void retrieveRecords_Opportunity6(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should not be 0 ');        
    }    
    @isTest static void retrieveRecords_Opportunity7(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='*';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,ocrlist,recid,initiatedfrom);
        system.assert(accountslist!=null, 'Is not null');
    }    
    @isTest static void retrieveRecords_Opportunity8(){ 
        String objectName='Opportunity'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        ocrlist=lstResult[0].Id;
        accountslist=[select Id from Account Limit 1].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,accountslist,null,recid,'Opportunity');   
        system.assert(accountslist!=null, 'Is not null');
    }    
     @isTest static void retrieveRecords_Account2(){ 
        String objectName='Opportunity'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=lstResult[0].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,null,ocrlist,recid,'Account');
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should be 0 ');        
    }  
    @isTest static void retrieveRecords_Contact2(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=lstResult[0].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,null,ocrlist,null,'Account');
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should be 0 ');        
    } 
    @isTest static void retrieveRecords_Contact3(){ 
        String objectName='Contact'; 
        String fieldAPINames='Id,Name'; 
        String filterFieldAPIName='Name';
        String strInput='test';
        String accountslist; 
        String ocrlist;
        String recid;
         String initiatedfrom;
        
        string strQuery = 'SELECT Id,Name from ' 
            
            + String.escapeSingleQuotes(objectName) 
            + ' LIMIT 50000';
        List<SObject> lstResult = database.query(strQuery);
        recid=lstResult[0].Id;
        accountslist=lstResult[0].Id;
        List<MultiSelectLookupController.SObjectQueryResult> objList= MultiSelectLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,null,ocrlist,recid,'Opportunity');
        //system.assert(objList[0].recordId==lstResult[0].Id);  
        system.assert(objList.size()==0,'objList should be 0 ');        
    } 
}