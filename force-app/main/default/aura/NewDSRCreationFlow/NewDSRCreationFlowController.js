({
    doInit : function(component, event, helper) {
        if(component.get("v.vfPage") == true){
            component.set("v.recId",component.get("v.recordId")); 
        }else{
            component.set("v.recId",component.get("v.pageReference").state.c__recId);
            component.set("v.instanceName",component.get("v.pageReference").state.c__instanceName);
        }   
        var action = component.get("c.getObjectName");
        action.setParams({
            "recId":component.get("v.recId"),
            "InstanceName":component.get("v.instanceName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.objectValues",response.getReturnValue());
                if(component.get("v.objectValues").instanceName=='true'){
                  //  component.set("v.objectName",component.get("v.objectValues").instanceName);                   
                    component.set("v.objectName",component.get("v.objectValues").objectName);
                    component.set("v.opptyAccId",component.get("v.objectValues").accountId); 
                    component.set("v.recordName",component.get("v.objectValues").recordName);
                    component.set("v.campaignadmin",component.get("v.objectValues").campaignIdAdmin);
                    component.set("v.showContactCheck",component.get("v.objectValues").showContactCheckbox);
                    
                    var saveDSR = component.get("c.saveDSRObject");
                    saveDSR.setParams({
                        "nameDSR":component.get("v.recordName"),
                        "objectName":component.get("v.objectName"),
                        "recId":component.get("v.recId"),
                        "InstanceName":component.get("v.instanceName")
                    });
                    saveDSR.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.dsrid",response.getReturnValue());
                        }
                });
                
                $A.enqueueAction(saveDSR);  
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'The provided instance name does exist, please check your instance name and try again. The BriefingSource instances are configured under Admin Settings.',
                        message: 'Error Occurred',
                        duration: '2000',
                        type: 'error'
                    });
                    toastEvent.fire();
         
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.recId"),
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error Message',
                    message: 'Error Occurred',
                    duration: '2000',
                    type: 'error'
                });
                toastEvent.fire();
                
            }
        });
        
        $A.enqueueAction(action);        
    },
    onPageReferenceChanged: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})