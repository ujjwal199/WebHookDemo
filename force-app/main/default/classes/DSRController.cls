public with sharing virtual class DSRController {
    
    protected List<EVApi.Center> centers;
    
    public List<SelectOption> centerOptions {get; protected set;}
    public List<SelectOption> briefingTypeOptions {get; protected set;}
    
    public BS_Deal_Support_Request__c dsr {get; set;}
    public Account accObj {get; set;}
    public Opportunity oppObj {get; set;}
    //public Id accountId {get; set;}
    //public String accountName {get; set;}
    public Boolean canChangeDsr {get; set;}
    public Boolean renderCanvas {get; set;}
    public Boolean canvasLocked {get; set;}
    public String canvasInstanceName {get; set;}
    public String canvasAppDomain {
        get {
            string instanceName = ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
            bsource__BriefingSourceSettingsList__c briefingSourceSettings = bsource__BriefingSourceSettingsList__c.getAll().get(instanceName);


            System.debug('briefingSourceSettings777'+briefingSourceSettings);
            System.debug('briefingSourceSettings'+briefingSourceSettings.API_Endpoint__c);

            //bsource__BriefingSourceSettingsList__c briefingSourceSettings = bsource__BriefingSourceSettingsList__c.getValues('Tushar7');
            //BriefingSourceSettings__c briefingSourceSettings = BriefingSourceSettings__c.getOrgDefaults();
             if (briefingSourceSettings.API_Endpoint__c != null) {
                canvasAppDomain = briefingSourceSettings.API_Endpoint__c.substringBetween('//', '.');
            }
            return canvasAppDomain;
        }
        
        private set;
    }
    
    
    public DSRController() {
        try{
           string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
            bsource__BriefingSourceSettingsList__c objSettings = bsource__BriefingSourceSettingsList__c.getValues(instanceName);
           // bsource__BriefingSourceSettings__c objSettings = bsource__BriefingSourceSettings__c.getOrgDefaults();
            if(objSettings != null && String.isBlank(objSettings.bsource__API_Endpoint__c) 
               && String.isBlank(objSettings.bsource__API_Username__c)
               && String.isBlank(objSettings.bsource__API_Password__c) 
               && String.isBlank(objSettings.bsource__Client_Id__c)
               && String.isBlank(objSettings.bsource__Client_Secret__c)){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter briefing source connection details on admin settings'));
                   return;
               }
            
            Id dsrId = ApexPages.currentPage().getParameters().get('dsrId');
            Id accountId = ApexPages.currentPage().getParameters().get('accountId');
            Id opptyId = ApexPages.currentPage().getParameters().get('opptyId');
            canvasInstanceName = instanceName;
            if(accountId != null)
                accObj = [Select Id,Name from Account where Id = :accountId WITH SECURITY_ENFORCED];
            
            if(opptyId != null)
                oppObj = [Select Id, Name, AccountId, Account.Name from Opportunity where Id = :opptyId WITH SECURITY_ENFORCED];
            
            if (dsrId == null) {
                dsr = new BS_Deal_Support_Request__c();
                dsr.Status__c = 'Draft';
            } else {
               Set<String> fields = new Set<String>{'Name','Status__c','Center__c','Briefing_Objective__c','Briefing_Type__c', 'Site_Name__c', 'Account__c',	               
                        'Opportunity__c','Requestor__c','BriefingID__c','Confirmed_Date__c','ConfirmedTime__c','RoomLocation__c', 'ContactName__c','Briefing_Doc_Link__c','Admin_Comments__c','bsource__BriefingSource_InstanceName__c','bsource__BriefingSource_API_URL__c'
                        };
                            
                            String soql = 'SELECT ' + String.escapeSingleQuotes(String.join(new List<String>(fields), ',')) + ' '
                            + 'FROM BS_Deal_Support_Request__c '
                            + 'WHERE Id = :dsrId';
                
                dsr = Database.query(soql);
                System.debug('dsr---->'+dsr.center__c);
            }
        }catch(Exception e){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<String> lstString = LABEL.DevEmails.split(',');
            message.toAddresses = lstString;message.optOutPolicy = 'FILTER';message.subject = 'Exception occured';
            String body = 'Hi team <br/>';message.plainTextBody = 'Hi team <br/>Following error occured while sending DSR request to briefing source <br/> on line'+e.getLineNumber()+' error message'+e.getMessage()+'<br/>'+e.getStackTraceString();
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
              //  Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
        }
    }
    
    public void initPage() {
        try{
           string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
            bsource__BriefingSourceSettingsList__c objSettings = bsource__BriefingSourceSettingsList__c.getValues(instanceName);
            //bsource__BriefingSourceSettings__c objSettings = bsource__BriefingSourceSettings__c.getOrgDefaults();
            if(objSettings != null 
               && String.isBlank(objSettings.bsource__API_Endpoint__c) 
               && String.isBlank(objSettings.bsource__API_Username__c)
               && String.isBlank(objSettings.bsource__API_Password__c) 
               && String.isBlank(objSettings.bsource__Client_Id__c)
               && String.isBlank(objSettings.bsource__Client_Secret__c)){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter briefing source connection details on admin settings'));
                   return;
               }
            canChangeDsr = (dsr.Status__c == 'Draft' || dsr.Status__c == 'Pending' ||  dsr.Status__c == 'Updates Required');
            
            if (dsr.Status__c != 'Draft' && dsr.Status__c != 'Pending' && dsr.Status__c != 'Updates Required') {
                canvasLocked = true;
            } else if (dsr.Id != null) {
                renderCanvas = true;
            }
            
            if (canvasLocked != true) {
                centerOptions = new List<SelectOption>();
                briefingTypeOptions = new List<SelectOption>();
                centers = EVApi.getCenters();
                System.debug('centers--->'+centers.size());
                System.debug('centers--->'+centers);
                // Default the Center and Briefing Type if there is only one option.
                if (dsr.Center__c == null && centers.size() == 1) {
                    dsr.Center__c = centers[0].id;
                    //if(!Test.isRunningTest()){
                    if (dsr.Briefing_Type__c == null && centers[0].briefingTypes.size() == 1 ) {
                        dsr.Briefing_Type__c = centers[0].briefingTypes[0].id;
                    } 
                    // if(centers[0].briefingTypes.size() > 0 ){
                    for (EVApi.BriefingType briefingType : centers[0].briefingTypes) {
                        briefingTypeOptions.add(new SelectOption(String.valueOf(briefingType.id), briefingType.name));
                    } 
                   // }
                   
                    //}
                }
                
                for (EVApi.Center center : centers) {
                    centerOptions.add(new SelectOption(String.valueOf(center.id), center.name));
                }
            }
            
            /* khushboo commented
              renderCanvas = true;
              canvasLocked = false;*/
            renderCanvas = true;
        }catch(Exception e){
         /*   Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<String> lstString = LABEL.DevEmails.split(',');
            message.toAddresses = lstString;
            message.optOutPolicy = 'FILTER';
            message.subject = 'Exception occured';
            String body = 'Hi team <br/>';
            message.plainTextBody = 'Hi team <br/>Following error occured while sending DSR request to briefing source <br/> on line'+e.getLineNumber()+' error message'+e.getMessage()+'<br/>'+e.getStackTraceString();
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
       */     
        }
    }
    
    public void changeCenter() {
        briefingTypeOptions = new List<SelectOption>();
        
        if (dsr.Center__c != null) {
            for (EVApi.Center center : centers) {
                if (dsr.Center__c == center.id && center.briefingTypes != null) {
                    for (EVApi.BriefingType briefingType : center.briefingTypes) {
                        briefingTypeOptions.add(new SelectOption(String.valueOf(briefingType.id), briefingType.name));
                    }
                    break;
                }
            }
        }
    } 
    
    public void save() {
        if (dsr.Center__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Schema.sObjectType.BS_Deal_Support_Request__c.fields.Center__c.getLabel() + ': You must select a value.'));
        }
        
        if (dsr.Briefing_Type__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Schema.sObjectType.BS_Deal_Support_Request__c.fields.Briefing_Type__c.getLabel() + ': You must select a value.'));
        }
        
        if (String.isBlank(dsr.Name)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Event/Briefing Name: You must enter a value.'));
        }
        
        if (String.isBlank(dsr.Briefing_Objective__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Schema.sObjectType.BS_Deal_Support_Request__c.fields.Briefing_Objective__c.getLabel() + ': You must enter a value.'));
        }
        
        if (ApexPages.hasMessages(ApexPages.Severity.ERROR)) {
            return;
        }
        if(Schema.sObjectType.BS_Deal_Support_Request__c.isAccessible() && Schema.sObjectType.BS_Deal_Support_Request__c.isCreateable()){
        insert dsr;
        }
        renderCanvas = true;
    }
    
}