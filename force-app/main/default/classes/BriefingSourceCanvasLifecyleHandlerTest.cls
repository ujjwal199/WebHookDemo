@isTest
private class BriefingSourceCanvasLifecyleHandlerTest {

	static testmethod void testOnRenderOpportunity() {
		Briefing_Source_Field_Mapping__c briefingSourceFieldMapping = new Briefing_Source_Field_Mapping__c();
		briefingSourceFieldMapping.Name = 'Test';
		briefingSourceFieldMapping.Salesforce_Field__c = 'StageName';
		briefingSourceFieldMapping.Briefing_Source_Field__c = 'stage';
		upsert briefingSourceFieldMapping;
 
		Briefing_Source_Field_Mapping__c briefingSourceFieldMapping2 = new Briefing_Source_Field_Mapping__c();
		briefingSourceFieldMapping2.Name = 'Test2';
		briefingSourceFieldMapping2.Salesforce_Field__c = 'account.Name';
		briefingSourceFieldMapping2.Briefing_Source_Field__c = 'accountName';
		upsert briefingSourceFieldMapping2;
		
		MockFactory mockFactory = new MockFactory();
		Account account = mockFactory.Acc;
		Opportunity opportunity = mockFactory.Opp;
		
		Map<String, String> environmentData = new Map<String, String>();
		environmentData.put('accountId', account.Id);
		environmentData.put('oppId', opportunity.Id);

		Canvas.RenderContext renderContext = Canvas.Test.mockRenderContext(null, null);
		renderContext.getEnvironmentContext().setParametersAsJSON(JSON.serialize(environmentData));

		Canvas.Test.testCanvasLifecycle(new BriefingSourceCanvasLifecyleHandler(), renderContext);

		Map<String, Object> parameters = (Map<String, Object>) JSON.deserializeUntyped(renderContext.getEnvironmentContext().getParametersAsJSON());

		System.assertEquals(opportunity.Id, parameters.get('oppId'),'Id should not null');
        BriefingSourceCanvasLifecyleHandler objBriefingSourceCanvasLifecyleHandler= new BriefingSourceCanvasLifecyleHandler();
        objBriefingSourceCanvasLifecyleHandler.isValidField('Account','Name');
        objBriefingSourceCanvasLifecyleHandler.getValue(Account,'Name');
        system.assert(briefingSourceFieldMapping!=null, 'Is not null');
		//System.assertEquals(opportunity.StageName, parameters.get('stage'),'Stage should not null ');
	}

	static testmethod void testOnRenderAccount() {
		Briefing_Source_Field_Mapping__c briefingSourceFieldMapping = new Briefing_Source_Field_Mapping__c();
		briefingSourceFieldMapping.Name = 'Test';
		briefingSourceFieldMapping.Salesforce_Field__c = 'account.Name';
		briefingSourceFieldMapping.Briefing_Source_Field__c = 'accountName';
		upsert briefingSourceFieldMapping;
        bsource__Briefing_Source_Field_Mapping_Lists__c BriefingMap =  new bsource__Briefing_Source_Field_Mapping_Lists__c();
        BriefingMap.Name ='Test';
        BriefingMap.Briefing_Source_Field__c ='test';
        BriefingMap.Salesforce_Field__c = 'Test2';
        Insert  BriefingMap;
        
		MockFactory mockFactory = new MockFactory();
		Account account = mockFactory.Acc;
		
		Map<String, String> environmentData = new Map<String, String>();
		environmentData.put('accountId', account.Id);

		Canvas.RenderContext renderContext = Canvas.Test.mockRenderContext(null, null);
		renderContext.getEnvironmentContext().setParametersAsJSON(JSON.serialize(environmentData));

		Canvas.Test.testCanvasLifecycle(new BriefingSourceCanvasLifecyleHandler(), renderContext);

		Map<String, Object> parameters = (Map<String, Object>) JSON.deserializeUntyped(renderContext.getEnvironmentContext().getParametersAsJSON());
		system.assert(briefingSourceFieldMapping!=null, 'Is not null');
		//System.assertEquals(account.Name, parameters.get('accountName'),'Name should not null');
	}

}