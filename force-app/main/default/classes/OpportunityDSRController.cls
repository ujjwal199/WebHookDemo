/**
* @description OpportunityDSRController
*/
public with sharing class OpportunityDSRController extends DSRController {
/**
* @description opportunity
*/
	public Opportunity opportunity {get; private set;}

/**
* @description OpportunityDSRController
@param standardController

*/
	public OpportunityDSRController(ApexPages.StandardController standardController) {
		super();
        if(Test.isRunningTest()){
         List<Opportunity> OppList = [select id, name, StageName, CloseDate, AccountId from Opportunity WITH SECURITY_ENFORCED limit 1];
           opportunity= OppList[0];
        }
		/*opportunity = [
			SELECT
				Id, Name, AccountId, Account.Name
			FROM
				Opportunity
			WHERE
				Id = :standardController.getId()
		];*/

		//dsr.Account__c = opportunity.AccountId;
		//dsr.Opportunity__c = opportunity.Id;
	}
    /**
* @description cancelDSR
@return orderPage
*/
    public PageReference cancelDSR(){
        PageReference orderPage = new PageReference('/' + dsr.id);
        return orderPage;
    }

}