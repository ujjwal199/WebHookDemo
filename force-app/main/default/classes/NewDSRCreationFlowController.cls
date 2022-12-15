/**
* @description AccountDSRController
*/
public with sharing class NewDSRCreationFlowController {
    /**
* @description AccountDSRController
@param recId
@return Map
*/
    public static Boolean  instanceNameExists{get;set;}
    Public NewDSRCreationFlowController(){
        NewDSRCreationFlowController.showToastMsg();
    }
    @AuraEnabled
    public static Map<String,String> getObjectName(Id recId,String InstanceName){
        Map<String,String> objectMap = new Map<String,String>();
        List<String> campaignIdAdmin = new List<String>();
        if(recId != null){
            bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsList = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName); 
            if(BriefingSourceSettingsList!= null && BriefingSourceSettingsList.Name != null){
                objectMap.put('instanceName','true');
                
                String sObjName = recId.getSObjectType().getDescribe().getName();
                objectMap.put('objectName',sObjName);
                if(sObjName == 'Opportunity' && Schema.sObjectType.Opportunity.isAccessible()){
                    Opportunity oppty = [SELECT AccountId,Name from Opportunity where Id = :recId LIMIT 1];
                    objectMap.put('accountId',oppty.AccountId);
                    objectMap.put('recordName',oppty.Name);
                }
                if(sObjName == 'Account' && Schema.sObjectType.Account.isAccessible()){
                    String accName = [SELECT Name from Account where Id = :recId].Name;
                    objectMap.put('recordName',accName);
                }
                
                bsource__Campaign_Ids_Lists__c customSettings = bsource__Campaign_Ids_Lists__c.getValues(InstanceName); 
                if(customSettings!= null && customSettings.bsource__Show_Campaign_Checkbox__c == true){ objectMap.put('campaignIdAdmin','true');
                }
                else{
                    objectMap.put('campaignIdAdmin','false');
                }
                bsource__Show_Contact_Lists__c showContactSetting = bsource__Show_Contact_Lists__c.getValues(InstanceName);             
                if(showContactSetting!= null && showContactSetting.bsource__Show_Contact_Checkbox__c==true){
                    objectMap.put('showContactCheckbox','true');
                }
                else{
                    objectMap.put('showContactCheckbox','false'); 
                }            
            }
            else{
                objectMap.put('instanceName','false'); 
            }
            return objectMap;
            
            
        }else{
            return null;
        }
        
    }
    /**
* @description saveDSRObject
@param nameDSR @param objectName @param recId
*/
    @AuraEnabled
    public static Id saveDSRObject(String nameDSR, String objectName, Id recId,String InstanceName){
        if(Schema.sObjectType.bsource__BS_Deal_Support_Request__c.isCreateable() && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.isAccessible()
         
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.Status__c.isAccessible()          
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__Account__c.isAccessible()
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__BriefingSource_InstanceName__c.isAccessible()
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.Name.isAccessible()
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.Status__c.isCreateable()          
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__Account__c.isCreateable()
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__BriefingSource_InstanceName__c.isCreateable()
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.Name.isCreateable()
                      && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__BriefingSource_API_URL__c.isCreateable()
                       && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__Opportunity__c.isCreateable()
                       && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__Opportunity__c.isAccessible()


                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isCreateable() && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.isAccessible()
                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isAccessible()
                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.Name.isCreateable()
                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isAccessible() 
                 && Schema.sObjectType.bsource__BriefingSourceSettingsLists__c.fields.bsource__API_Endpoint__c.isCreateable() 

           && Schema.sObjectType.bsource__DSR_Campaign__c.isCreateable() && Schema.sObjectType.bsource__DSR_Campaign__c.isAccessible()
           && Schema.sObjectType.bsource__Campaign_Id__c.isAccessible()
          ){
              bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName);
              bsource__BS_Deal_Support_Request__c dsrObject;
              List<String> campaignIdAdmin = new List<String>();
              List<bsource__DSR_Campaign__c> dsrRelationsList = new List<bsource__DSR_Campaign__c>();
              String DsrtrimName;
               if(nameDsr.length()>80){
                      //trim name
                      DsrtrimName=nameDSR.mid(0,80);
                  }else{
                     DsrtrimName=nameDSR;
                  }
              if(objectName == 'Account' ){
                 
                  
                  dsrObject = new bsource__BS_Deal_Support_Request__c(Name=DsrtrimName,bsource__Dsr_Name__c=nameDSR, Status__c='Draft',bsource__Account__c=recId,
                                                                      bsource__BriefingSource_InstanceName__c=InstanceName,bsource__BriefingSource_API_URL__c=bss.bsource__API_Endpoint__c);
              }
              if(objectName == 'Opportunity'){
                  dsrObject = new bsource__BS_Deal_Support_Request__c(Name=DsrtrimName,bsource__Dsr_Name__c=nameDSR, Status__c='Draft',bsource__Opportunity__c=recId,
                                                                      bsource__BriefingSource_InstanceName__c=InstanceName,bsource__BriefingSource_API_URL__c=bss.bsource__API_Endpoint__c );
              }
              if(dsrObject !=null){
                     database.insert(dsrObject);
              }
             
             /* bsource__Campaign_Ids_List__c customSettings = bsource__Campaign_Ids_List__c.getValues(InstanceName); 
              // bsource__Campaign_Id__c customSettings = bsource__Campaign_Id__c.getOrgDefaults();
              if(customSettings!= null && customSettings.bsource__Campaign_Id__c != null && customSettings.bsource__Campaign_Id__c != ''){
                  campaignIdAdmin = customSettings.bsource__Campaign_Id__c.split(',');
                  System.debug('campaignIdAdmin :: ' +campaignIdAdmin);
                  for(Id campaignId: campaignIdAdmin){
                      bsource__DSR_Campaign__c dsrRelations= new bsource__DSR_Campaign__c();
                      dsrRelations.bsource__Deal_Support_Request__c = dsrObject.Id;
                      dsrRelations.bsource__Campaign__c = campaignId;
                      dsrRelationsList.add(dsrRelations);
                  }
                  if(dsrRelationsList!=null && !dsrRelationsList.isEmpty() && Schema.sObjectType.bsource__DSR_Campaign__c.isCreateable()){
                      Database.insert(dsrRelationsList);
                  }
              }*/
              return dsrObject.Id; }  else{  return null;}
        
    
    }
    
    
    @AuraEnabled 
    Public static  String  getpackagedetails()
    { 
        String UserName= System.UserInfo.getName();
        Id idName=System.UserInfo.getProfileId();
        List<Profile> profiledata= new List<Profile>();
        If( Schema.sObjectType.Profile.isAccessible()     && Schema.sObjectType.Profile.fields.id.isAccessible()
                 && Schema.sObjectType.Profile.fields.Name.isAccessible()){
                     profiledata= [SELECT Id, Name FROM Profile where id=:idName Limit 1];
            
        }
        String Name=UserName+' ('+profiledata[0].Name+')';
        return Name;
    }
        
        
    public static void showToastMsg(){
        String instanceName = apexpages.currentpage().getparameters().get('InstanceName');
        bsource__BriefingSourceSettingsLists__c BriefingSourceSettingsList = bsource__BriefingSourceSettingsLists__c.getValues(InstanceName); 
        if(BriefingSourceSettingsList== null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'The provided instance name does not exist, please check your instance name and try again. The BriefingSource instances are configured under Admin Settings.'));
        instanceNameExists = false;   }        else{     instanceNameExists = true;   }
    }
}