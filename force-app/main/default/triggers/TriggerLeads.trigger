trigger TriggerLeads on Lead (before Update) {
 System.debug('Is Update >>0'+trigger.isUpdate);
}