@RestResource(urlMapping='/DSR/v1/*')
global with sharing class DSRService {
	@HttpGet
    global static bsource__BS_Deal_Support_Request__c doGet() {
        RestRequest req = RestContext.request;
        String dsrId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug(dsrId);
        
        if (String.isEmpty(dsrId))
            return null;
        
        Set<String> dsr_fields	= fieldListFromFieldSet(SObjectType.BS_Deal_Support_Request__c.FieldSets.DSR_Fields, null);
        dsr_fields.addAll(fieldListFromFieldSet(SObjectType.Opportunity.FieldSets.Opportunity_Information, 'bsource__Opportunity__r'));
        dsr_fields.addAll(fieldListFromFieldSet(SObjectType.Opportunity.FieldSets.Account_Information, 'bsource__Opportunity__r'));
        List<String> dsrFieldList	= new List<String>(dsr_fields);
        
        String soql = 'SELECT ' + String.escapeSingleQuotes(String.join(dsrFieldList, ', ')) +
        			  ' FROM bsource__BS_Deal_Support_Request__c' +
            		  ' WHERE Id = :dsrId';
        System.debug('DSR Apex REST SOQL: ' + soql);
        List<bsource__BS_Deal_Support_Request__c> records =new List<bsource__BS_Deal_Support_Request__c>();
        if(bsource__BS_Deal_Support_Request__c.SObjectType.getDescribe().isAccessible() ){
            records = (List<bsource__BS_Deal_Support_Request__c>)Database.query(soql); 
        }
        if (records.size() == 1)
            return records.get(0);
        else
            return null;
    }
    
    private static Set<String> fieldListFromFieldSet(Schema.FieldSet fldSet, String parentRefPrfx) {
        Set<String> fields	= new Set<String>();
        
        Map<String, Schema.SObjectField> fieldMap = fldSet.getSObjectType().getDescribe().fields.getMap();
        
        for (Schema.FieldSetMember fsm : fldSet.getFields()) {
            String fieldPath	= fsm.getFieldPath();
            
            if (String.isEmpty(parentRefPrfx)) {
                if (fieldMap.get(fieldPath).getDescribe().isAccessible()) {
                   fields.add(fieldPath);
            	}
            } else {
                fields.add(parentRefPrfx + '.' + fieldPath);
            }
        }
        return fields;
    }
}