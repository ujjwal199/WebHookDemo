({
	doInit : function(component, event, helper) {
        console.log('test1234',component.get("v.recordId"));
        $A.get("e.force:closeQuickAction").fire();
		var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "bsource__NewDSRCreationFlow"
                
                
            }, 
            "state": {
                'c__recId'     : component.get("v.recordId")
            }
        };
        navService.navigate(pageReference);
	}
})