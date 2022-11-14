public with sharing class CreateDSRRelations {
    
    @AuraEnabled
    public static void saveAccountDSRRecords(String accountIds, String dsrRelationshipId, String recid, String objectname){
        System.debug('saveAccountDSRRecords'+accountIds + ' : ' + dsrRelationshipId);
        System.debug('account objectname'+objectname + ' : ' + recid);
        List<String> lstaccountIds = new List<String>();
        List<bsource__DSR_Account__c> dsrRelationsList = new List<bsource__DSR_Account__c>();
        List<bsource__DSR_Account__c> deleteRelationsList = new List<bsource__DSR_Account__c>();
        
        if(dsrRelationshipId!= '' && dsrRelationshipId!=null){
            if(accountIds!= '' && accountIds!=null){
                lstaccountIds = accountIds.split(',');
            }
            if( bsource__DSR_Account__c.SObjectType.getDescribe().isAccessible() &&
               Schema.SObjectType.bsource__DSR_Account__c.fields.bsource__Deal_Support_Request__c.isAccessible()){
                   deleteRelationsList = [SELECT Id FROM bsource__DSR_Account__c WHERE
                                          bsource__Deal_Support_Request__c = :dsrRelationshipId
                                          AND bsource__Account__c!= null];
               }
            if(deleteRelationsList!=null && !deleteRelationsList.isEmpty() && bsource__DSR_Account__c.SObjectType.getDescribe().isAccessible() && bsource__DSR_Account__c.SObjectType.getDescribe().isDeletable()){
                Database.delete(deleteRelationsList);
            }
            
            system.debug('deleteRelationsList'+deleteRelationsList);
            
            for(Id accId: lstaccountIds){
                bsource__DSR_Account__c dsrRelations= new bsource__DSR_Account__c();
                dsrRelations.bsource__Deal_Support_Request__c = dsrRelationshipId;
                dsrRelations.bsource__Account__c = accId;
                dsrRelationsList.add(dsrRelations);
            }
            if(recid!=null && recid!='' && objectname=='Account'){
                bsource__DSR_Account__c dsrRelationMain= new bsource__DSR_Account__c();
                dsrRelationMain.bsource__Deal_Support_Request__c = dsrRelationshipId;
                dsrRelationMain.bsource__Account__c = recid;
                dsrRelationsList.add(dsrRelationMain);
            }
            if(dsrRelationsList!=null && !dsrRelationsList.isEmpty() && bsource__DSR_Account__c.SObjectType.getDescribe().isAccessible() && bsource__DSR_Account__c.SObjectType.getDescribe().isCreateable()){
                Database.insert(dsrRelationsList);
            }
            System.debug('accountIds dsrRelationsList'+dsrRelationsList);
        }
    }
    
    @AuraEnabled
    public static void saveOpptyDSRRecords(String opptyIds, String dsrRelationshipId, String recid, String objectname){
        System.debug('saveOpptyDSRRecords'+opptyIds + ' : ' + dsrRelationshipId);
        System.debug('oppty objectname'+objectname + ' : ' + recid);
        List<String> lstopptyIds = new List<String>();
        List<bsource__DSR_Opportunity__c> dsrRelationsList = new List<bsource__DSR_Opportunity__c>();
        List<bsource__DSR_Opportunity__c> deleteRelationsList = new List<bsource__DSR_Opportunity__c>();
        
        
        if(dsrRelationshipId!= '' && dsrRelationshipId!=null && bsource__DSR_Opportunity__c.SObjectType.getDescribe().isAccessible()){
            if(opptyIds!= '' && opptyIds!=null){
                lstopptyIds = opptyIds.split(',');
            }
            
            deleteRelationsList = [SELECT Id FROM bsource__DSR_Opportunity__c WHERE
                                   bsource__Deal_Support_Request__c = :dsrRelationshipId
                                   AND bsource__Opportunity__c!= null];
            
            if(deleteRelationsList!=null && !deleteRelationsList.isEmpty()  && bsource__DSR_Opportunity__c.SObjectType.getDescribe().isDeletable()){
                Database.delete(deleteRelationsList);
            }
            System.debug('oppty lstopptyIds'+lstopptyIds);
            for(Id opptyId: lstopptyIds){
                bsource__DSR_Opportunity__c dsrRelations= new bsource__DSR_Opportunity__c();
                dsrRelations.bsource__Deal_Support_Request__c = dsrRelationshipId;
                dsrRelations.bsource__Opportunity__c = opptyId;
                dsrRelationsList.add(dsrRelations);
            }
            
            if(recid!=null && recid!='' && objectname=='Opportunity'){
                bsource__DSR_Opportunity__c dsrRelationMain= new bsource__DSR_Opportunity__c();
                dsrRelationMain.bsource__Deal_Support_Request__c = dsrRelationshipId;
                dsrRelationMain.bsource__Opportunity__c = recid;
                dsrRelationsList.add(dsrRelationMain);
            }
            
            if(dsrRelationsList!=null && !dsrRelationsList.isEmpty() && bsource__DSR_Opportunity__c.SObjectType.getDescribe().isCreateable()){
                Database.insert(dsrRelationsList);
            }
            System.debug('opptyIds dsrRelationsList'+dsrRelationsList);
        }
        
    }
    
    @AuraEnabled
    public static void saveContactDSRRecords(String contactIds, String dsrRelationshipId){
        System.debug('contactIds :'+contactIds);
        System.debug('saveContactDSRRecords'+contactIds + ' : ' + dsrRelationshipId);
        List<bsource__DSR_Contact__c> dsrRelationsList = new List<bsource__DSR_Contact__c>();
        List<bsource__DSR_Contact__c> deleteRelationsList = new List<bsource__DSR_Contact__c>();
        
        // @deb Delete last contact 25_07_2022 starts here
        List<bsource__DSR_Contact__c> contactlast = new List<bsource__DSR_Contact__c>();
        if (contactIds=='' && dsrRelationshipId!='' && bsource__DSR_Contact__c.SObjectType.getDescribe().isDeletable()){
            contactlast = [SELECT Id, bsource__Contact__c FROM bsource__DSR_Contact__c WHERE bsource__Deal_Support_Request__c =:dsrRelationshipId AND bsource__Contact__c!= ''];
            System.debug('contactlast :'+contactlast.size()); 
            if(contactlast.size() > 0){
                Database.delete(contactlast);
            }
        }
        System.debug('Last contact delete id: '+contactlast);
        // Delete last contact 25_07_2022 ends here
        
        if(contactIds!= '' && contactIds!=null && dsrRelationshipId!= '' && dsrRelationshipId!=null  && bsource__DSR_Contact__c.SObjectType.getDescribe().isAccessible()){
            List<String> lstcontactIds = contactIds.split(',');
            
            deleteRelationsList = [SELECT Id FROM bsource__DSR_Contact__c WHERE
                                   bsource__Deal_Support_Request__c = :dsrRelationshipId
                                   AND bsource__Contact__c!= null];
            
            if(deleteRelationsList!=null && !deleteRelationsList.isEmpty() && bsource__DSR_Contact__c.SObjectType.getDescribe().isDeletable()){
                Database.delete(deleteRelationsList);
            }             
            
            for(Id contactId: lstcontactIds){
                bsource__DSR_Contact__c dsrRelations= new bsource__DSR_Contact__c();
                dsrRelations.bsource__Deal_Support_Request__c = dsrRelationshipId;
                dsrRelations.bsource__Contact__c = contactId;
                dsrRelationsList.add(dsrRelations);
            }
            if(dsrRelationsList!=null && !dsrRelationsList.isEmpty() && bsource__DSR_Contact__c.SObjectType.getDescribe().isCreateable()){
                Database.insert(dsrRelationsList);
            }
            System.debug('contactIds dsrRelationsList'+dsrRelationsList);
        }
    }
    
    @AuraEnabled
    public static void saveCampaignDSRRecords(String campaignIds, String dsrRelationshipId,String instanceName){
        System.debug('saveCampaignDSRRecords'+campaignIds + ' : ' + dsrRelationshipId);
        List<bsource__DSR_Campaign__c> dsrRelationsList = new List<bsource__DSR_Campaign__c>();
        List<bsource__DSR_Campaign__c> deleteRelationsList = new List<bsource__DSR_Campaign__c>();
        List<String> defaultCampaignId = new List<String>();
        List<String> selectedCampaignId = new List<String>();
        
        
        List<String> combinedCampList = new List<String>();  
        bsource__Campaign_Ids_Lists__c customSettings = bsource__Campaign_Ids_Lists__c.getValues(instanceName); 
        if(customSettings!= null && customSettings.bsource__Campaign_Id__c != null && customSettings.bsource__Campaign_Id__c != ''){
            defaultCampaignId = customSettings.bsource__Campaign_Id__c.split(',');
        } 
        
        if(campaignIds!= '' && campaignIds!=null && dsrRelationshipId!= '' &&   bsource__DSR_Campaign__c.SObjectType.getDescribe().isAccessible()){
            selectedCampaignId = campaignIds.split(',');
        }
        if(dsrRelationshipId!=null){
            deleteRelationsList = [SELECT Id FROM bsource__DSR_Campaign__c WHERE
                                   bsource__Deal_Support_Request__c = :dsrRelationshipId
                                   AND bsource__Campaign__c!= null];
        }
        if(deleteRelationsList!=null && !deleteRelationsList.isEmpty() && bsource__DSR_Campaign__c.SObjectType.getDescribe().isDeletable()){
            Database.delete(deleteRelationsList);
        }
        
        combinedCampList.addAll(defaultCampaignId);
        combinedCampList.addAll(selectedCampaignId);
        Set<String> combinedCampSet = new Set<String>(combinedCampList);
        for(Id campaignId: combinedCampSet){
            bsource__DSR_Campaign__c dsrRelations= new bsource__DSR_Campaign__c();
            dsrRelations.bsource__Deal_Support_Request__c = dsrRelationshipId;
            dsrRelations.bsource__Campaign__c = campaignId;
            dsrRelationsList.add(dsrRelations);
        }
        if(dsrRelationsList!=null && !dsrRelationsList.isEmpty() && bsource__DSR_Campaign__c.SObjectType.getDescribe().isCreateable()){
            Database.insert(dsrRelationsList);
        }
        System.debug(' campaignIds dsrRelationsList'+dsrRelationsList);
        
    }
    
    // New code for save HelpDesk data 
    
    // @Deb
    @AuraEnabled
    public static List<bsource__HelpDesk__c> getHelpDeskRecord(String instanceName) {
        List<bsource__HelpDesk__c> helpDeskList = new List<bsource__HelpDesk__c>();
        if( bsource__HelpDesk__c.SObjectType.getDescribe().isAccessible() &&
           Schema.SObjectType.bsource__HelpDesk__c.fields.bsource__Account_Help_Text__c.isAccessible()
           && Schema.SObjectType.bsource__HelpDesk__c.fields.bsource__Contact_Help_Text__c.isAccessible()
           && Schema.SObjectType.bsource__HelpDesk__c.fields.bsource__Campaign_Help_Text__c.isAccessible()
           && Schema.SObjectType.bsource__HelpDesk__c.fields.bsource__Opportunity_Help_Text__c.isAccessible()){
               helpDeskList = [SELECT Id, bsource__Account_Help_Text__c, bsource__Contact_Help_Text__c, bsource__Campaign_Help_Text__c, bsource__Opportunity_Help_Text__c FROM bsource__HelpDesk__c WHERE bsource__Instance_Name__c =:instancename order by CreatedDate desc];
           }
        return helpDeskList;
    }
}