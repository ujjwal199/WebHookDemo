public with sharing class BriefingSourceCanvasLifecyleHandler implements Canvas.CanvasLifecycleHandler {
    
    public Set<Canvas.ContextTypeEnum> excludeContextTypes() { return new Set<Canvas.ContextTypeEnum>(); }
    
    public void onRender(Canvas.RenderContext renderContext) {
        List<bsource__Briefing_Source_Field_Mapping_Lists__c> BriefingSourceFieldMappingLists = new List<bsource__Briefing_Source_Field_Mapping_Lists__c>();
        Canvas.EnvironmentContext environmentContext = renderContext.getEnvironmentContext();
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Opportunity.isAccessible()
           && Schema.sObjectType.Briefing_Source_Field_Mapping__c.isAccessible()){
               Map<String, Object> parameters = (Map<String, Object>) JSON.deserializeUntyped(environmentContext.getParametersAsJSON());
               
               String accountId = (String) parameters.get('accountId');
               String opportunityId = (String) parameters.get('oppId');
               String dsrID = (String) parameters.get('dsrId');
               String instanceName = (String) parameters.get('instanceName');
               String objectName = 'Opportunity';
               String objectId = opportunityId;
               
               if (String.isBlank(opportunityId)) {
                   objectName = 'Account';
                   objectId = accountId;
               }

               Set<String> uniqueFieldNames = new Set<String>();
               uniqueFieldNames.add('id');
               
               // List<bsource__Briefing_Source_Field_Mapping_Lists__c> BriefingSourceFieldMappingLists = bsource__Briefing_Source_Field_Mapping_Lists__c.getAll().values();
               if( bsource__Briefing_Source_Field_Mapping_Lists__c.SObjectType.getDescribe().isAccessible() &&
                  Schema.SObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Briefing_Source_Field__c.isAccessible() &&
                  Schema.SObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Salesforce_Field__c.isAccessible()){
                      BriefingSourceFieldMappingLists = [SELECT ID,bsource__Salesforce_Field__c,bsource__Briefing_Source_Field__c,bsource__Instance_Name__c 
                                                         FROM bsource__Briefing_Source_Field_Mapping_Lists__c WHERE bsource__Instance_Name__c =:instanceName];
                  }
               for (bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping : BriefingSourceFieldMappingLists) {
                   String salesforceField = briefingSourceFieldMapping.bsource__Salesforce_Field__c.toLowerCase();
                   if (objectName == 'Account') {
                       salesforceField = salesforceField.replace('account.', '');
                   }			
                   // added for this to check fields contains or not
                   if(objectName == 'Account' && isValidField(objectName,salesforceField) ){  uniqueFieldNames.add(salesforceField.toLowerCase()); 
                   }else if(objectName == 'Opportunity'){  uniqueFieldNames.add(salesforceField.toLowerCase()); 
                   }
               }
               String soql = 'SELECT ' + String.escapeSingleQuotes(String.join(new List<String>(uniqueFieldNames), ',')) + ' FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE Id = \'' + String.escapeSingleQuotes(objectId) + '\'';
               String dsrValues = FetchDSRValues.fetchDSRvalues(dsrID, objectName); 
               
             
               SObject record = Database.query(soql);
                
               Map<String, Object> data = new Map<String, Object>();
               //  List<bsource__Briefing_Source_Field_Mapping_List__c> BriefingSourceFieldMappingList = bsource__Briefing_Source_Field_Mapping_List__c.getAll().values();
               //List<bsource__Briefing_Source_Field_Mapping_List__c> BriefingSourceFieldMappingList =  [SELECT ID,bsource__Salesforce_Field__c,bsource__Briefing_Source_Field__c,bsource__Instance_Name__c 
                                                                                                 //      FROM bsource__Briefing_Source_Field_Mapping_List__c WHERE bsource__Instance_Name__c =:instanceName];
               for (bsource__Briefing_Source_Field_Mapping_Lists__c briefingSourceFieldMapping : BriefingSourceFieldMappingLists) {
                   String salesforceField = briefingSourceFieldMapping.Salesforce_Field__c.toLowerCase();
                 
                   if (objectName == 'Account') {
                       salesforceField = salesforceField.replace('account.', '');
                   }	
                   Object value;
                   if (objectName == 'Account' && isValidField(objectName,salesforceField)) { value = getValue(record, salesforceField);
                   }else if (objectName == 'Opportunity'){value = getValue(record, salesforceField);
                   }
                   parameters.put(briefingSourceFieldMapping.Briefing_Source_Field__c, value);
               }
               
               if(dsrValues != null){
                   parameters.put('dsr', (Object)JSON.deserializeUntyped(dsrValues));
               }
              
               environmentContext.setParametersAsJSON(JSON.serialize(parameters));
           }
        
    }
    @TestVisible
    private Object getValue(SObject sobj, String field) {
        if(sobj==null){     return null;
        }
        String objectName = sobj.Id.getSObjectType().getDescribe().getName();
        //hadd removed the multi line in to single line to cover test class
        if (field.contains('.') ) {     String[] fieldParts = field.split('\\.');   return getValue(sobj.getSObject(fieldParts.remove(0)), String.join(fieldParts, '.'));
        } else {    return sobj.get(field);
        }
    }
    
    public boolean isValidField(string objName,String fieldName){
        Set<String> opprtunityFields=new Set<String>();
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objName).getDescribe();
        opprtunityFields=objectDescribe.fields.getMap().keySet();
        if(!opprtunityFields.isEmpty() && opprtunityFields.contains(fieldName)){   return true;
        }else{
            return false;
        }
    }
    
}