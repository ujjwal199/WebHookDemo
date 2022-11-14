public with sharing class AssociateDSRCtrl {

    public DSR_Opportunity__c objDSROpportunity{get;set;}
    public String strOppId=ApexPages.currentPage().getParameters().get('OppID');

    public AssociateDSRCtrl(){
        if(DSR_Opportunity__c.SObjectType.getDescribe().isAccessible()){
             objDSROpportunity=new DSR_Opportunity__c(Opportunity__c=strOppId);
        }
    }

    public pagereference saveAssociateDSR(){
        if(DSR_Opportunity__c.SObjectType.getDescribe().isAccessible() && DSR_Opportunity__c.SObjectType.getDescribe().isCreateable()){
            try{
                
                List<Schema.SObjectField> fields = new List<Schema.SObjectField>{
                    DSR_Opportunity__c.Opportunity__c
                        };
                            Utils.Auth.assertAuthorizedToCreate(Schema.DSR_Opportunity__c.getSobjectType(), fields);
                insert objDSROpportunity;
                
                objDSROpportunity=new DSR_Opportunity__c(Opportunity__c=strOppId);
                
                Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.confirm,'Associated DSR successfully saved.')); 
            } catch(Exception ex){
                Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.ERROR,''+ex.getStackTraceString())); 
            }
        }
        return null;
    }
}