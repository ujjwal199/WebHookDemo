trigger BriefingAttendeeTrigger on bsource__Briefing_Attendee__c (before insert,before update) {
    bsource__Trigger_Switch__c customSettings = bsource__Trigger_Switch__c.getOrgDefaults();
    if(customSettings.bsource__Attendee_Trigger__c){
        if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
            BriefingAttendeeTriggerHandler.insertContact(trigger.New);
        }
    }
}