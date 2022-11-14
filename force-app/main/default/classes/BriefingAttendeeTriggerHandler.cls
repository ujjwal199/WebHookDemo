public with sharing class BriefingAttendeeTriggerHandler {
    public static void insertContact(List<bsource__Briefing_Attendee__c> attendeeList){
        system.debug('attendeeList>>'+attendeeList);
        List<bsource__Briefing_Attendee__c> attendeeListToUpdate = new List<bsource__Briefing_Attendee__c>();
        Map<String,List<Contact>> contactMap = new Map<String,List<Contact>>();
        Set<String> emailSet = new Set<String>();
        
        for(bsource__Briefing_Attendee__c objAttendee : attendeeList){
            if(String.isNotBlank(objAttendee.bsource__Email__c)){
                emailSet.add(objAttendee.bsource__Email__c);
            }
        }
        
        for(Contact objContact : [select id,Email from Contact where Email IN: emailSet order by createddate desc]){
            if(contactMap.containsKey(objContact.Email) && contactMap.get(objContact.Email) != null){
                contactMap.get(objContact.Email).add(objContact);
            }else{
                contactMap.put(objContact.Email, new List<Contact>{ objContact });
            }
        }
        
        for(bsource__Briefing_Attendee__c objAttendee : attendeeList){
            if(contactMap.containsKey(objAttendee.bsource__Email__c) && contactMap.get(objAttendee.bsource__Email__c) != null){
               objAttendee.bsource__Contact__c = contactMap.get(objAttendee.bsource__Email__c)[0].Id;                
            }else if(!contactMap.containsKey(objAttendee.bsource__Email__c) ){
                objAttendee.bsource__Contact__c = null;
            }
        }
    }
}