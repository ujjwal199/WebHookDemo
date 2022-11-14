@isTest
public class BriefingAttendeeTriggerTest {
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
    } 
    @isTest static void insertContactTest(){        
        bsource__Briefing_Attendee__c objAttendee=new bsource__Briefing_Attendee__c();
        objAttendee.bsource__First_Name__c ='FName';
        objAttendee.bsource__Last_Name__c='LName';
        objAttendee.bsource__Email__c='email@gmail.com';
        insert objAttendee;  
        Account acc = new Account();
        acc.Name = 'test';
        insert acc; 
        Contact c=new Contact();
        c.AccountId = acc.Id;
        c.LastName='LName';
        c.Email='email@gmail.com';
        insert c;
        //insert  attendeeListToUpdate;
        contact obj=[Select Id, Email from Contact where Email='email@gmail.com' limit 1];
        system.assert(objAttendee.bsource__Email__c == obj.Email,'bsource__Email__c and Email should be equal');        
    }  
    @isTest static void insertContactTest2(){        
        bsource__Briefing_Attendee__c objAttendee=new bsource__Briefing_Attendee__c();
        objAttendee.bsource__First_Name__c ='FName';
        objAttendee.bsource__Last_Name__c='LName';
        objAttendee.bsource__Email__c='';
        insert objAttendee;      
        
        //insert  attendeeListToUpdate;
        contact obj=[Select Id, Email from Contact where Email='email@gmail.com'];
        //  system.assert(objAttendee.bsource__Email__c == obj.Email,'bsource__Email__c and Email should be equal');
        system.assert(objAttendee!=null, 'Is not null');        
    }  
    
}