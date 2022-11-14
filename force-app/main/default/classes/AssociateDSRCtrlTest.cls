@isTest
private class AssociateDSRCtrlTest {

	private static testMethod void testAssociateDSRCtrl() {
       MockFactory mockData = new MockFactory();
       Opportunity opp = mockData.Opp;   
       
       system.assertNotEquals(null,opp.id,'Id Should not be null');
       
       ApexPages.CurrentPage().getparameters().put('OppID', opp.id);
       
       AssociateDSRCtrl objAssociateDSRCtrl=new AssociateDSRCtrl();
       objAssociateDSRCtrl.objDSROpportunity.Opportunity__c=opp.id;
       objAssociateDSRCtrl.objDSROpportunity.Deal_Support_Request__c=opp.id;
       
       objAssociateDSRCtrl.saveAssociateDSR();
	   
	   objAssociateDSRCtrl=new AssociateDSRCtrl();
	   objAssociateDSRCtrl.saveAssociateDSR();
	   
	}

}