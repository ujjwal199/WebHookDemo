public with sharing class AccountDSRController extends DSRController {
    //public Id dsrId {get;set;}
	public AccountDSRController(ApexPages.StandardController standardController) {
       // dsrId=apexpages.currentpage().getparameters().get('dsrId');
        try{
            super();
        }catch(Exception e){system.debug('exception occured>>'+e.getStackTraceString());
        }
		//dsr.Account__c = standardController.getId();
		}
    public PageReference cancelDSR(){//Id dsrId=apexpages.currentpage().getparameters().get('dsrId');
        PageReference orderPage = new PageReference('/' + dsr.id);
        return orderPage;
    }

}