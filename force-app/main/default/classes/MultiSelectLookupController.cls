public with sharing class MultiSelectLookupController {
    @AuraEnabled (cacheable=true)
    public static List<SObjectQueryResult> retrieveRecords(String objectName, String fieldAPINames, String filterFieldAPIName, String strInput, String accountslist , String ocrlist, String recid, String initiatedfrom){
         System.debug('objectName>>'+objectName);
         System.debug('fieldAPINames>>'+fieldAPINames);
         System.debug('filterFieldAPIName>>'+filterFieldAPIName);
         System.debug('strInput>>'+strInput);
         System.debug('initiatedfrom>>'+initiatedfrom);
         System.debug('accountslist>>'+accountslist);

         
        List<SObjectQueryResult> lstReturnResult = new List<SObjectQueryResult>();
        List<SObjectQueryResult> lstReturnResultContact = new List<SObjectQueryResult>();
        Boolean mainAccountSelected = false;
        String listopptyaccountId = '';
        
        if(strInput.equals('*')){
            strInput = '';
        }
        
        String opptyPreselection ='';
        Set<String> listOpportunityIds = new Set<String>();
        if(initiatedfrom == 'Opportunity'){
            opptyPreselection =  'AND Id NOT IN (\''+ String.escapeSingleQuotes(recid) + '\')';
            if(ocrlist != null && ocrlist!=''){
                List<String> lstocrIds = ocrlist.split(',');
                for(String strValue : lstocrIds){
                    listOpportunityIds.add(strValue);
                }
                if(recid!=null){
                    listOpportunityIds.add(recid);
                }
            }else{
                if(recid!=null){
                    listOpportunityIds.add(recid);
                }
            }
            System.debug('opptyPreselection>>'+opptyPreselection);
            
            if(listOpportunityIds != null && !listOpportunityIds.isEmpty() && Opportunity.SObjectType.getDescribe().isAccessible()){
                 system.debug('listOpportunityIds'+listOpportunityIds);
                List<Opportunity> accountIdOppty = [SELECT AccountId FROM Opportunity WHERE Id IN :listOpportunityIds];
                for(Opportunity accId: accountIdOppty){
                    if(accId.AccountId!=null)
                    listopptyaccountId+= '\''+accId.AccountId +'\',';
                }
                listopptyaccountId = listopptyaccountId.removeEnd(',');
            }
            
        }
        
        system.debug('listopptyaccountId '+listopptyaccountId);
        String str = strInput + '%';
        String strQueryField = '';
        List<String> fieldList = fieldAPINames.split(','); 
        strQueryField = fieldAPINames;
        
        String strQuery;
        String strQueryOCR;
        String listaccountId = '';
        if(accountslist != null && accountslist!=''){
            List<String> lstaccountIds = accountslist.split(',');
            for(String strValue : lstaccountIds){  
                listaccountId+= '\''+strValue +'\',';
            }
            listaccountId = listaccountId.removeEnd(',');
        }
        
        if(initiatedfrom == 'Account' && recid!=null){
            listaccountId+= ',\''+recid +'\'';
        }
        
        if(initiatedfrom == 'Account' && recid!=null && (accountslist == null || accountslist=='')){
            mainAccountSelected = true;
            listaccountId= '\''+recid +'\'';
        }
        
        String listocrId = ''; 
        system.debug('strQueryField'+strQueryField);
        if (objectName == 'Account' && Account.SObjectType.getDescribe().isAccessible() ){
            strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField) 
                + ' FROM ' 
                + String.escapeSingleQuotes(objectName) 
                + ' WHERE ' + String.escapeSingleQuotes(filterFieldAPIName) + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                + ' AND Id NOT IN (\''+  String.escapeSingleQuotes(recid) + '\')'
                + ' ORDER BY LastModifiedDate DESC'
                + ' LIMIT 50';//50000
        }
        
        if (objectName == 'Opportunity' && Opportunity.SObjectType.getDescribe().isAccessible()){
            System.debug('mainAccountSelected>>'+mainAccountSelected);
            if(accountslist != null && accountslist!='' && !mainAccountSelected){
                system.debug('accountslist>>'+accountslist);
                system.debug('listaccountId>>'+listaccountId);
                strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField) 
                    + ' FROM ' 
                    + String.escapeSingleQuotes(objectName) 
                    + ' WHERE ' + String.escapeSingleQuotes(filterFieldAPIName) + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                    + ' AND ' + 'AccountId IN (' + listaccountId + ')' + opptyPreselection
                    + ' ORDER BY LastModifiedDate DESC'
                    + ' LIMIT 50';// 50000
                system.debug('opptyPreselection '+opptyPreselection);
            }
            
            else if(mainAccountSelected && Schema.getGlobalDescribe().get(objectName).getDescribe().isAccessible()){
                strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField) 
                    + ' FROM ' 
                    + String.escapeSingleQuotes(objectName) 
                    + ' WHERE ' + String.escapeSingleQuotes(filterFieldAPIName) + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                    + ' AND ' + 'AccountId IN (' + listaccountId + ')'
                    + ' ORDER BY LastModifiedDate DESC'
                    + ' LIMIT 50'; // 50000
                system.debug('opptyPreselection '+opptyPreselection);
            }else{
                strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField) 
                    + ' FROM ' 
                    + String.escapeSingleQuotes(objectName) 
                    + ' WHERE ' + String.escapeSingleQuotes(filterFieldAPIName) + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\' ' + opptyPreselection
                    + ' ORDER BY LastModifiedDate DESC'
                    + ' LIMIT 50'; // 50000
                system.debug('opptyPreselection '+opptyPreselection);
                system.debug('String.escapeSingleQuotes(opptyPreselection)>>>'+String.escapeSingleQuotes(opptyPreselection));
            }
            system.debug('strQuery '+strQuery);
            for(SObject sobj:database.query(strQuery)) 
            { listocrId+= '\''+(String) sobj.get('Id') +'\',';
            }
            listocrId = listocrId.removeEnd(',');
        }
        
        if (objectName == 'Contact' && Contact.SObjectType.getDescribe().isAccessible()){
            if(initiatedfrom == 'Account'){
                if(accountslist != null && accountslist!='' && !mainAccountSelected){
                    strQuery = 'SELECT Id , Name FROM ' 
                        + String.escapeSingleQuotes('Contact') 
                        + ' WHERE Name' + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                        + ' AND ' + 'AccountId IN (' + listaccountId + ')'
                       + ' ORDER BY LastModifiedDate DESC'
                       + ' LIMIT 50'; // 50000
                    System.debug('strQuery=====>'+strQuery);
                }else if(mainAccountSelected){
                    strQuery = 'SELECT Id, Name FROM ' 
                        + String.escapeSingleQuotes('Contact') 
                        + ' WHERE Name' + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                        + ' AND ' + 'AccountId IN (' + listaccountId + ')'
                        + ' ORDER BY LastModifiedDate DESC'
                        + ' LIMIT 50'; // 50000
                      System.debug('strQuery=====>'+strQuery);
                }
                else{
                    strQuery = 'SELECT Id, Name FROM ' 
                        + String.escapeSingleQuotes('Contact') 
                        + ' WHERE Name' + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                        + ' ORDER BY LastModifiedDate DESC'
                        + ' LIMIT 50'; // 50000
                      System.debug('strQuery=====>'+strQuery);
                }
            }else{
                if(listopptyaccountId != null && listopptyaccountId!=''){     strQuery = 'SELECT Id, Name FROM '  + String.escapeSingleQuotes('Contact')  + ' WHERE Name' + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\'' + ' AND ' + 'AccountId IN (' + listopptyaccountId + ')'+ ' ORDER BY LastModifiedDate DESC'+ ' LIMIT 50'; // 50000
                      System.debug('strQuery=====>'+strQuery);
                }
                else{
                    strQuery = 'SELECT Id, Name FROM ' 
                        + String.escapeSingleQuotes('Contact') 
                        + ' WHERE Name' + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''+ ' ORDER BY LastModifiedDate DESC' + ' LIMIT 50'; // 50000
                      System.debug('strQuery=====>'+strQuery);
                }
            }
        }
        
        if (objectName == 'Campaign' && Campaign.SObjectType.getDescribe().isAccessible() ){
            //SELECT Id FROM Campaign WHERE IsActive = true
            strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField) 
                + ' FROM ' 
                + String.escapeSingleQuotes(objectName) 
                + ' WHERE ' + String.escapeSingleQuotes(filterFieldAPIName) + '  LIKE \'%' + String.escapeSingleQuotes(str) + '%\''
                + ' AND IsActive = true'
               + ' ORDER BY LastModifiedDate DESC'
               + ' LIMIT 50'; // 50000
        }
        
        System.debug('strQuery=' + strQuery);
        
        List<SObject> lstResult = database.query(strQuery);
        
        
        System.debug('retrieveRecords lstResult'+lstResult);
        System.debug('retrieveRecords fieldList'+fieldList);
        //create list of records that can be easily be parsable at js controller.
        Map<String,String> removeDuplicate= new Map<String,String>();
        if (objectName == 'Contact'){
            for(SObject sobj:lstResult){
                SObjectQueryResult result = new SObjectQueryResult();
                result.recordId = (String) sobj.get('Id');
                result.recordName = (String) sobj.get('Name');
                lstReturnResultContact.add(result);
                System.debug('lstReturnResultContact=====>'+lstReturnResultContact);
                removeDuplicate.put((String) sobj.get('Id'),(String) sobj.get('Name'));
            }
            Set<SObjectQueryResult> uniqueset = new Set<SObjectQueryResult>();
            uniqueset.addAll(lstReturnResultContact);
            system.debug('uniqueset'+uniqueset);
            lstReturnResult.addAll(uniqueset);
            system.debug('lstReturnResult'+lstReturnResult);
        }
        else{
            for(String strField:fieldList){
                for(SObject sobj:lstResult){                
                    if(strField != 'Id'){
                        SObjectQueryResult result = new SObjectQueryResult();
                        result.recordId = (String) sobj.get('Id');
                        result.recordName = (String) sobj.get(strField);
                        lstReturnResult.add(result);
                    }                
                }
            }
        }
        return lstReturnResult;
    }
    
    public class SObjectQueryResult {
        @AuraEnabled
        public String recordId;
        
        @AuraEnabled
        public String recordName;
    }
}