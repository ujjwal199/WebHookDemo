public with sharing class DSRCtrl {
    
    enum MovementDirection { Next, Previous }
    static final DSRUIModel.WizardStage[] WizardStages = new DSRUIModel.WizardStage[]{
        DSRUIModel.WizardStage.Attendees, 
            DSRUIModel.WizardStage.Site, DSRUIModel.WizardStage.Topics,
            DSRUIModel.WizardStage.AddInfo, DSRUIModel.WizardStage.Review};
                
                private List<EVApi.Center> centers;
    
    // Single enacapsulated page state 
    public DSRUIModel.WizardState state {get;set;}
    public integer index{get;set;}
    public boolean renderCanvas {get;set;}
    public boolean canvasLocked {get;set;} //Lock the record once the record is Submitted 
    public List<SelectOption> centerOptions {get; private set;}
    public List<SelectOption> briefingTypeOptions {get; private set;}
    
    public DSRCtrl() {}
    
    public DSRCtrl(ApexPages.StandardController ctrl) {
        // CRUD FLS CHECK
        try {
            assertCRUDFLS();
        } catch (Exception e) {     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have the necessary CRUD/FLS permissions to successfully complete the process. Please contact your administrator.'));
        }
        
        this.state = new DSRUIModel.WizardState();
        //system.debug('$$$$'+this.state.dsr.status__c);
        //Render Canvas or Not Depending on the DSR Status and DSR ID
        if(this.state.dsr.Id == null){  renderCanvas = false;   canvasLocked = false;
            /*
centerOptions = new List<SelectOption>();
briefingTypeOptions = new List<SelectOption>();

centers = EVApi.getCenters();

for (EVApi.Center center : centers) {
centerOptions.add(new SelectOption(String.valueOf(center.id), center.name));
}
*/
        }else{
            if(this.state.dsr.status__c == 'Submitted' || this.state.dsr.status__c == 'Confirmed'){  canvasLocked = true;           renderCanvas = false;//Do not render Canvas since DSR is locked
            }else{
                renderCanvas = true; // Render the Canvas as the DSR is in draft state
                canvasLocked = false;
            }  
        }
        //temporary setup for quick testing
        String stage = ApexPages.currentPage().getParameters().get('stage').escapeHtml4();
        if (stage == null) {
            this.state.stage = WizardStages[0];//first stage
            gotoEditableStage(MovementDirection.Next, WizardStages[0]);
        } else {
            this.state.stage = forName(stage);
            if (this.state.stage == DSRUIModel.WizardStage.Attendees) {
                toStepAttendees();
            } else if (this.state.stage == DSRUIModel.WizardStage.Site) {
                toStepSites();
            } else if (this.state.stage == DSRUIModel.WizardStage.AddInfo) {
                this.state.stage = DSRUIModel.WizardStage.AddInfo;
            } else if (this.state.stage == DSRUIModel.WizardStage.Review) {
                this.state.stage = DSRUIModel.WizardStage.Review;
                toStepReview();
            }    
        }
    }
    
    public void changeCenter() {
        briefingTypeOptions = new List<SelectOption>();
        
        if (state.dsr.Center__c != null) {    for (EVApi.Center center : centers) {
                                               if (state.dsr.Center__c == center.id) {
                                                  for (EVApi.BriefingType briefingType : center.briefingTypes) {
                                       briefingTypeOptions.add(new SelectOption(String.valueOf(briefingType.id), briefingType.name));
                                                                                    }
                                           break;
                                        }
                                  }
        }
    }
    @testVisible
    void assertCRUDFLS() {
        if(BS_Deal_Support_Request__c.SObjectType.getDescribe().isAccessible()){
            List<Schema.SObjectField> fields = new List<Schema.SObjectField>{
                BS_Deal_Support_Request__c.Name,
                    BS_Deal_Support_Request__c.Status__c,
                    BS_Deal_Support_Request__c.Primary_Date__c,
                    BS_Deal_Support_Request__c.Alternative_Date__c,
                    BS_Deal_Support_Request__c.Site_ID__c,
                    BS_Deal_Support_Request__c.Site_Name__c
                    };
                        fields.addAll(Utils.sobjFieldsFromFieldSet(SObjectType.BS_Deal_Support_Request__c.FieldSets.DSR_Fields, Schema.BS_Deal_Support_Request__c.SObjectType));
            Utils.Auth.assertAuthorizedToCreate(Schema.BS_Deal_Support_Request__c.getSobjectType(), fields);
            
            fields = new List<Schema.SObjectField>{Briefing_Attendee__c.Contact__c, Briefing_Attendee__c.Deal_Support_Request__c};
                Utils.Auth.assertAuthorizedToCreate(Schema.Briefing_Attendee__c.getSobjectType(), fields);
            
            fields = new List<Schema.SObjectField>{Briefing_Topic__c.Name, 
                Briefing_Topic__c.Topic_Id__c,
                Briefing_Topic__c.Category_Id__c,
                Briefing_Topic__c.Category_Name__c,
                Briefing_Topic__c.Notes__c,
                Briefing_Topic__c.Deal_Support_Request__c};
                    Utils.Auth.assertAuthorizedToCreate(Schema.Briefing_Topic__c.getSobjectType(), fields);
            
            fields = new List<Schema.SObjectField>{Opportunity.Name};
                Utils.Auth.assertAuthorizedToView(Schema.Opportunity.getSobjectType(), fields);
            
            fields = new List<Schema.SObjectField>{Contact.Name, Contact.Title, Contact.AccountId};
                Utils.Auth.assertAuthorizedToView(Schema.Contact.getSobjectType(), fields);
            
            fields = new List<Schema.SObjectField>{OpportunityContactRole.Role, OpportunityContactRole.ContactId, OpportunityContactRole.OpportunityId};
                Utils.Auth.assertAuthorizedToView(Schema.OpportunityContactRole.getSobjectType(), fields);
            
            fields = new List<Schema.SObjectField>{AccountContactRole.Role, AccountContactRole.ContactId, AccountContactRole.AccountId};
                Utils.Auth.assertAuthorizedToView(Schema.AccountContactRole.getSobjectType(), fields);
            
        }
    }
    
    void moveInWizard(MovementDirection dir) {
        Integer idxOfCurrStage = 0;
        for (DSRUIModel.WizardStage ws: WizardStages) {
            if (ws == this.state.stage) {   break;  }    idxOfCurrStage++;  }
        
        idxOfCurrStage =  dir == MovementDirection.Next ? ++idxOfCurrStage : --idxOfCurrStage;
        System.debug (idxOfCurrStage);        
        DSRUIModel.WizardStage reqdStage = idxOfCurrStage < 0 || idxOfCurrStage >= WizardStages.size() ?  DSRUIModel.WizardStage.Review : WizardStages[idxOfCurrStage];
        
        this.state.stage = reqdStage;
        gotoEditableStage(dir, reqdStage);
    }
    
    @testVisible
    void gotoEditableStage(MovementDirection dir, DSRUIModel.WizardStage reqdStage) {
        
        if (reqdStage == DSRUIModel.WizardStage.Attendees && (this.state.canChangeDSRName || this.state.canChangeAttendees)) {
            toStepAttendees(); return;
        } 
        if (reqdStage == DSRUIModel.WizardStage.Site && this.state.canChangeSites) {
            toStepSites(); return;
        } 
        if (reqdStage == DSRUIModel.WizardStage.Topics && this.state.canChangeTopics) {
            toStepTopics(); return;
        } 
        if (reqdStage == DSRUIModel.WizardStage.AddInfo && this.state.canChangeAddInfo) {
            toStepAddInfo(); return;
        } 
        if (reqdStage == DSRUIModel.WizardStage.Review) {
            toStepReview(); return;    
        } 
        
        // cant go anywhere move again 
        moveInWizard(dir);
    }
    
    public void moveNextInWizard() {
        moveInWizard(MovementDirection.Next);
    }
    public void movePreviousInWizard() {
        moveInWizard(MovementDirection.Previous);
    }
    @TestVisible
    private void fetchcurrentDSR(){
        String currentNamespace = DSRCtrl.class.getName().substringBefore('DSRCtrl').removeEnd('.');
        if (!String.isEmpty(currentNamespace)) {
            currentNamespace += '__';
        }
        
        Set<String> dsrFields = new Set<String>{
            'name',
                currentNamespace + 'briefing_objective__c',  
                currentNamespace + 'status__c', 
                currentNamespace + 'site_id__c', 
                currentNamespace + 'site_name__c', 
                currentNamespace + 'primary_date__c',
                currentNamespace + 'meeting_duration__c',
                currentNamespace + 'meetinghours__c',
                currentNamespace + 'alternative_date__c',
                currentNamespace + 'starttime__c',
                currentNamespace + 'endtime__c',
                currentNamespace + 'center__c',
                currentNamespace + 'briefing_type__c'};
                    dsrFields.addAll(Utils.fieldsFromFieldSet(SObjectType.BS_Deal_Support_Request__c.FieldSets.DSR_Fields, Schema.BS_Deal_Support_Request__c.SObjectType));
        
        String dsrSoql = 'Select ' +  String.escapeSingleQuotes(Utils.toCSV(new List<String>(dsrFields))) + ', ' +
            ' (Select Name, Category_Name__c, Notes__c from Briefing_Topics__r order by Category_Name__c), ' +
            ' (Select Contact__c, Contact__r.Name, Contact__r.Title from Briefing_Attendees__r where Contact__c!=null order by Contact__r.Name) ' +                                         
            ' from BS_Deal_Support_Request__c  where Id =:dsrId ';
        Id dsrId = this.state.dsrId;     this.state.dsr = Database.query(dsrSoql);
        Set<String> oppFields = new Set<String>();
        oppFields.addAll(Utils.fieldsFromFieldSet(SObjectType.Opportunity.FieldSets.Opportunity_Information, Schema.Opportunity.SObjectType));
        oppFields.addAll(Utils.parentFieldsFromFieldSet(SObjectType.Opportunity.FieldSets.Account_Information));
        
        String oppSoql = 'Select ' +  String.escapeSingleQuotes(Utils.toCSV(new List<String>(oppFields))) + ' from Opportunity  where Id =:oppId';
        
        Id oppId=this.state.oppId;
        this.state.relatedOpportunity = (oppFields.size()==0)?new Opportunity():Database.query(oppSoql);
    }
    
    public PageReference addNewRowAdHocAttendee(){ 
        isCompleted=false;
        if(this.state.adHocAttendees==null){ this.state.adHocAttendees=new List<Briefing_Attendee__c>(); }
        
        this.state.adHocAttendees.add(new Briefing_Attendee__c());
        
        return null;
    }
    
    public PageReference removeAdHocAttendee(){ 
        if(this.state.adHocAttendees!=null && this.state.adHocAttendees.size()>=index){this.state.adHocAttendees.remove(index); }
        
        return null;
    }    
    
    public boolean isCompleted{get;set;}
    public PageReference AddToAttendeeList(){ 
        isCompleted=true;
        return null;   
    }    
    
    public PageReference verifyAdohAttendeeList(){ 
        List<Briefing_Attendee__c> lst=new List<Briefing_Attendee__c>();
        
        List<Schema.FieldSetMember> fieldsetList = SObjectType.Briefing_Attendee__c.FieldSets.Create_New_Ad_Hoc_Attendee.getFields();
        
        for(Briefing_Attendee__c obj:this.state.adHocAttendees){
            for(Schema.FieldSetMember fsm:fieldsetList){
                if(obj.get(fsm.getFieldPath())!=null && obj.get(fsm.getFieldPath())!=''){
                    lst.add(obj);
                    break;
                }
            }
        } 
        this.state.adHocAttendees=lst; 
        
        return null;
    }     
    
    public void onSaveAttendees() {        
        
        Map<String, Briefing_Attendee__c> existingAttendees = new Map<String, Briefing_Attendee__c>();
        Map<String, Briefing_Attendee__c> existingAdHocAttendees = new Map<String, Briefing_Attendee__c>();  
        System.debug ('this.state.dsrId: ' + this.state.dsrId);
        if (this.state.dsrId == null) {
            // create new dsr
            BS_Deal_Support_Request__c dsr = this.state.dsr;
            if(Schema.sObjectType.BS_Deal_Support_Request__c.isAccessible() && Schema.sObjectType.BS_Deal_Support_Request__c.isCreateable()){
                insert dsr; 
            }
            this.state.dsrId = dsr.Id;
        } else {
            BS_Deal_Support_Request__c origDSR = [Select (Select Contact__c from Briefing_Attendees__r ) 
                                                  from BS_Deal_Support_Request__c where Id =:this.state.dsrId WITH SECURITY_ENFORCED];            
            for (Briefing_Attendee__c ba : origDSR.Briefing_Attendees__r) {
                if(ba.Contact__c!=null){
                    existingAttendees.put(ba.Contact__c, ba);
                }else{
                    existingAdHocAttendees.put(ba.id,ba);
                } 
            } 
            
            BS_Deal_Support_Request__c dsr = this.state.dsr;
            if(dsr!=null && dsr.id!=null && Schema.sObjectType.BS_Deal_Support_Request__c.isAccessible() && Schema.sObjectType.BS_Deal_Support_Request__c.isUpdateable()){
                update dsr;
            }
        }
        
        
        Briefing_Attendee__c[] bas = new Briefing_Attendee__c[] {};
            Set <Id> contactIds = new Set <Id> ();
        for (DSRUIModel.Attendee att: this.state.probableAttendees) {
            if (att.selected && !contactIds.contains(att.contact.id)) {
                contactIds.add(att.contact.Id);
                Briefing_Attendee__c ba = existingAttendees.get(att.contact.Id);
                if (ba == null) {
                    ba = new Briefing_Attendee__c(Deal_Support_Request__c = this.state.dsrId, Contact__c = att.contact.Id) ;
                    bas.add(ba);                    
                }                               
                existingAttendees.remove(att.contact.Id);
            } 
        }
        
        
        if(this.state.adHocAttendees!=null && this.state.adHocAttendees.size()>0){
            for(Briefing_Attendee__c obj:this.state.adHocAttendees){
                obj.Deal_Support_Request__c=this.state.dsrId;
                
                if(obj.id!=null && existingAdHocAttendees.get(obj.id)!=null){
                    existingAdHocAttendees.remove(obj.id); 
                }
            }
        }
        
        if(this.state.adHocAttendees!=null && this.state.adHocAttendees.size()>0){
            upsert this.state.adHocAttendees;
        }        
        
        if (!existingAdHocAttendees.isEmpty()) {
            delete existingAdHocAttendees.values();  
        }
        
        
        
        if (!bas.isEmpty() && Schema.sObjectType.Briefing_Attendee__c.isAccessible() && Schema.sObjectType.Briefing_Attendee__c.isCreateable()) {
            insert bas;
        }
        
        if (!existingAttendees.isEmpty()) {
            delete existingAttendees.values();
        }
    }
    
    public void gotoAttendeesNext() {
        this.state.probableAttendees = null;   moveNextInWizard();
    }
    
    public void gotoSitesNext() {
        if(BS_Deal_Support_Request__c.sObjectType.getDescribe().isAccessible() && BS_Deal_Support_Request__c.sObjectType.getDescribe().isUpdateable()
           && Schema.sObjectType.BS_Deal_Support_Request__c.fields.Site_ID__c.isUpdateable() &&  Schema.sObjectType.BS_Deal_Support_Request__c.fields.Primary_Date__c.isUpdateable() 
           && Schema.sObjectType.BS_Deal_Support_Request__c.fields.Site_Name__c.isUpdateable() && Schema.sObjectType.BS_Deal_Support_Request__c.fields.Meeting_Duration__c.isUpdateable()
           && Schema.sObjectType.BS_Deal_Support_Request__c.fields.Alternative_Date__c.isUpdateable() && Schema.sObjectType.BS_Deal_Support_Request__c.fields.EndTime__c.isUpdateable()
           && Schema.sObjectType.BS_Deal_Support_Request__c.fields.StartTime__c.isUpdateable()){
               BS_Deal_Support_Request__c dsr = new BS_Deal_Support_Request__c(Id = this.state.dsrId);
               dsr.Site_ID__c = this.state.selectedSite;
               dsr.Site_Name__c = this.state.selectedSiteName;
               dsr.Alternative_Date__c = this.state.getSelectedAlternateDateObj();
               dsr.Primary_Date__c = this.state.getSelectedPrimaryDateObj();
               dsr.Meeting_Duration__c=this.state.selectedMeetingDurationType;
               dsr.StartTime__c=this.state.selectedStartTime;
               dsr.EndTime__c=this.state.selectedEndTime;
               update dsr;	
           }
        // clear view state        
        this.state.selectedSite = null;
        this.state.selectedSiteName = null; 
        this.state.selectedPrimaryDate = null;
        this.state.selectedAlternateDate = null;
        this.state.selectedMeetingDurationType = null;
        
        //toStepTopics();
        moveNextInWizard();
    }
    
    public void gotoTopicsNext() {
        if(Briefing_Topic__c.sObjectType.getDescribe().isAccessible() ){
            Briefing_Topic__c[] topics = [Select Id from Briefing_Topic__c Where Deal_Support_Request__c =:this.state.dsrId];
            if (topics == null || topics.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Topics Selected'));       
            } else {
                // toStepAddInfo();            
                moveNextInWizard();
            } 
        }
    }
    
    public void gotoAddInfoNext() {
        if(BS_Deal_Support_Request__c.sObjectType.getDescribe().isAccessible()  && BS_Deal_Support_Request__c.sObjectType.getDescribe().isUpdateable()){
            update this.state.dsr;
            //        toStepReview();
            moveNextInWizard(); 
        }
      
    }    
    
    public void toStepAttendees() {
        this.state.stage = DSRUIModel.WizardStage.Attendees;        
        this.state.probableAttendees = new DSRUiModel.Attendee[]{};
            this.state.adHocAttendees = new List<Briefing_Attendee__c>();
        // ids of contacts selected as attendees
        Set<Id> selectedAttendees = new Set<Id>();
        Set<Id> selectedAdHocAttendees = new Set<Id>();
        
        Id dsrId = this.state.dsrId;
        if (BS_Deal_Support_Request__c.sObjectType.getDescribe().isAccessible() && Briefing_Attendee__c.sObjectType.getDescribe().isAccessible() && dsrId != null) {
            BS_Deal_Support_Request__c dsr = [Select Name,Briefing_Objective__c, Status__c, Admin_Comments__c, (Select id, Contact__c from Briefing_Attendees__r where isDeleted=false) from BS_Deal_Support_Request__c where Id =:this.state.dsrId WITH SECURITY_ENFORCED];
            // load existing attendees
            this.state.dsr = dsr.clone(true); // less view state of related lists for this panel
            if (dsr.Briefing_Attendees__r != null) {
                for (Briefing_Attendee__c ba : dsr.Briefing_Attendees__r) {
                    if(ba.Contact__c!=null){
                        selectedAttendees.add(ba.Contact__c);
                    }else{
                        selectedAdHocAttendees.add(ba.id);
                    }    
                }
            }
            //Q : what if some attendee is registered with DSR, but deleted from opp or account ? 
        }
        
        Set<Id> fetchedContactIds = new Set<Id>();
        for (OpportunityContactRole ocr: [Select Role, ContactId, Contact.Name, Contact.Title 
                                          From OpportunityContactRole Where OpportunityId = : this.state.oppId]) {
                                              fetchedContactIds.add(ocr.ContactId);    
                                              this.state.probableAttendees.add(new DSRUIModel.Attendee(ocr.Contact, ocr.Role, selectedAttendees.contains(ocr.ContactId)));
                                          }
        
        if(selectedAdHocAttendees!=null && selectedAdHocAttendees.size()>0){
            Set<String> adHocAttendeesField=new Set<String>();
            adHocAttendeesField.addAll(Utils.fieldsFromFieldSet(SObjectType.Briefing_Attendee__c.FieldSets.Create_New_Ad_Hoc_Attendee, Schema.Briefing_Attendee__c.SObjectType));
            
            String strSoql='Select ' +  String.escapeSingleQuotes(Utils.toCSV(new List<String>(adHocAttendeesField)))+' from Briefing_Attendee__c where id IN:selectedAdHocAttendees order by First_Name__c';
            
            for (Briefing_Attendee__c ba:Database.query(strSoql)) {
                this.state.adHocAttendees.add(ba);
            }
        }
        
        
        Id accountId = [Select AccountId from Opportunity Where Id = : this.state.oppId].AccountId;
        if (Account.sObjectType.getDescribe().isAccessible() && Contact.sObjectType.getDescribe().isAccessible() && accountId != null) {
            for (AccountContactRole acr: [Select Role, ContactId, Contact.Name, Contact.Title 
                                          From AccountContactRole Where AccountId = : accountId and ContactId NOT IN:fetchedContactIds]) {
                                              this.state.probableAttendees.add(new DSRUIModel.Attendee(acr.Contact, acr.Role, selectedAttendees.contains(acr.ContactId)));
                                              fetchedContactIds.add(acr.ContactId);    
                                          }
            
            for (Contact con: [Select Name, Title 
                               From Contact Where AccountId = : accountId and Id NOT IN:fetchedContactIds]) {
                                   this.state.probableAttendees.add(new DSRUIModel.Attendee(con, '-', selectedAttendees.contains(con.Id)));
                               }
        }
        
        if (this.state.probableAttendees.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.msg_dsr_no_contact));
        }
    }
    
    public void toStepSites() {    
        if(BS_Deal_Support_Request__c.sObjectType.getDescribe().isAccessible()){
            this.state.stage = DSRUIModel.WizardStage.Site;
            
            BS_Deal_Support_Request__c dsr = [Select Site_ID__c, site_name__c, Alternative_Date__c, Primary_Date__c,Meeting_Duration__c,StartTime__c,EndTime__c from BS_Deal_Support_Request__c where Id =:this.state.dsrId];
            this.state.selectedSite = dsr.Site_ID__c;
            this.state.selectedSiteName = dsr.site_name__c;                
            this.state.selectedPrimaryDate = Utils.toISOStringFromDate(dsr.Primary_Date__c);   
            this.state.selectedAlternateDate = Utils.toISOStringFromDate(dsr.Alternative_Date__c); 
            this.state.selectedMeetingDurationType = dsr.Meeting_Duration__c;  
            this.state.selectedStartTime = dsr.StartTime__c; 
            this.state.selectedEndTime = dsr.EndTime__c; 
            // load api data
            this.state.sitesResponse = EVAPI.DataSource.loadSites(new DSRUIModel.SitesRequest()); 
        }
    }   
    public void toStepTopics() {
        if(BS_Deal_Support_Request__c.sObjectType.getDescribe().isAccessible()){
            BS_Deal_Support_Request__c dsr = [Select Site_ID__c, site_name__c from BS_Deal_Support_Request__c where Id =:this.state.dsrId];
            this.state.selectedSite = dsr.Site_ID__c;
            this.state.selectedSiteName = dsr.site_name__c;                
            this.state.stage = DSRUIModel.WizardStage.Topics;
        }     
    } 
    
    public void toStepAddInfo() { 
        String currentNamespace = DSRCtrl.class.getName().substringBefore('DSRCtrl').removeEnd('.');
        if (!String.isEmpty(currentNamespace)) {
            currentNamespace += '__';
        }
        
        Id dsrId = this.state.dsrId;    Set<String> dsrFields = new Set<String>{'name', currentNamespace + 'status__c'};
            dsrFields.addAll(Utils.fieldsFromFieldSet(SObjectType.BS_Deal_Support_Request__c.FieldSets.DSR_Fields, Schema.BS_Deal_Support_Request__c.SObjectType));
        String dsrSoql = 'Select ' + String.escapeSingleQuotes(Utils.toCSV(new List<String>(dsrFields)))  + ' from BS_Deal_Support_Request__c where Id =:dsrId ';
        this.state.dsr = Database.query(dsrSoql);
        
        this.state.stage = DSRUIModel.WizardStage.AddInfo;
    }
    
    
    public void toStepReview() {
        String currentNamespace = DSRCtrl.class.getName().substringBefore('DSRCtrl').removeEnd('.');
        if (!String.isEmpty(currentNamespace)) {
            currentNamespace += '__';
        }
        
        Set<String> dsrFields = new Set<String>{
            'name',
                currentNamespace + 'briefing_objective__c', 
                currentNamespace + 'status__c', 
                currentNamespace + 'site_id__c', 
                currentNamespace + 'site_name__c', 
                currentNamespace + 'primary_date__c',
                currentNamespace + 'meeting_duration__c',
                currentNamespace + 'meetinghours__c',
                currentNamespace + 'alternative_date__c',
                currentNamespace + 'starttime__c',
                currentNamespace + 'endtime__c'};
                dsrFields.addAll(Utils.fieldsFromFieldSet(SObjectType.BS_Deal_Support_Request__c.FieldSets.DSR_Fields, Schema.BS_Deal_Support_Request__c.SObjectType));
        
        String dsrSoql = 'Select ' +  String.escapeSingleQuotes(Utils.toCSV(new List<String>(dsrFields))) + ', ' +
            ' (Select Name, Category_Name__c, Notes__c from Briefing_Topics__r order by Category_Name__c), ' +
            ' (Select Contact__c, Contact__r.Name, Contact__r.Title from Briefing_Attendees__r where Contact__c!=null order by Contact__r.Name) ' +                                         
            ' from BS_Deal_Support_Request__c  where Id =:dsrId ';
        Id dsrId = this.state.dsrId;    this.state.dsr = Database.query(dsrSoql);
        
        this.state.adHocAttendees=new List<Briefing_Attendee__c>();
        Set<String> adHocAttendeesField=new Set<String>();
        adHocAttendeesField.addAll(Utils.fieldsFromFieldSet(SObjectType.Briefing_Attendee__c.FieldSets.Create_New_Ad_Hoc_Attendee, Schema.Briefing_Attendee__c.SObjectType));
        
        if(adHocAttendeesField.size()>0){        
            String strSoql='Select ' +  String.escapeSingleQuotes(Utils.toCSV(new List<String>(adHocAttendeesField)))+' from Briefing_Attendee__c where Deal_Support_Request__c =:dsrId and Contact__c=null order by First_Name__c ';
            
            for (Briefing_Attendee__c ba:Database.query(strSoql)) {
                this.state.adHocAttendees.add(ba);
            }
        }
        
        
        
        Set<String> oppFields = new Set<String>();
        oppFields.addAll(Utils.fieldsFromFieldSet(SObjectType.Opportunity.FieldSets.Opportunity_Information, Schema.Opportunity.SObjectType));
        oppFields.addAll(Utils.parentFieldsFromFieldSet(SObjectType.Opportunity.FieldSets.Account_Information));
        
        String oppSoql = 'Select ' +  String.escapeSingleQuotes(Utils.toCSV(new List<String>(oppFields))) + ' from Opportunity  where Id =:oppId';
        
        Id oppId=this.state.oppId;
        this.state.relatedOpportunity = (oppFields.size()==0)?new Opportunity():Database.query(oppSoql);
        
        this.state.stage = DSRUIModel.WizardStage.Review;
    }
    
    public PageReference createDSR() {
        
        PageReference pr = null;
        Savepoint sp = Database.setSavepoint();
        try {
            //            Deal_Support_Request__c dsr = [Select Status__c from Deal_Support_Request__c where Id =:]
            // update status only if its a new DSR, no change in status else
          
            if(BS_Deal_Support_Request__c.sObjectType.getDescribe().isAccessible() && BS_Deal_Support_Request__c.sObjectType.getDescribe().isUpdateable()
              && Schema.sObjectType.BS_Deal_Support_Request__c.fields.Status__c.isUpdateable()){  
                  if (this.state.dsr.Status__c != null &&  (this.state.dsr.Status__c == 'Draft' || this.state.dsr.Status__c.equalsIgnoreCase('Updates Required'))
                  ){
                      this.state.dsr.Status__c = 'Submitted';
                      update this.state.dsr;
                  }    
            }
            
            if (this.state.dsrId == null) {
                pr = new PageReference('/' + this.state.oppId);                
            } else {
                // redirect to dsr page, if coming from there
                pr = new PageReference('/' + this.state.dsrId);               
            }
            
            pr.setRedirect(true);
        } catch (Exception ex) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Processing Failed - ' + ex.getMessage()));
        }
        
        return pr;
    }
    
    
    // missing enum from string support in salesforce, so have to give this helper method    
    DSRUIModel.WizardStage forName(String wizardStageName) {
        DSRUIModel.WizardStage result;
        for (DSRUIModel.WizardStage ws: DSRUIModel.WizardStage.values()) {
            if (ws.name() == wizardStageName) {
                result = ws;
                break;
            }
        }
        return result;
    }
    
    //Boolean to indicate the new wizard
    public boolean getIsClassicWizard(){
        string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();
            bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
        //bsource__BriefingSourceSettings__c  bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        boolean isClassicWizard = true;
        if(bss.bsource__Is_CanvasApp__c){
            isClassicWizard = false;
            if(this.state.dsr.status__c == 'Submitted' || this.state.dsr.status__c == 'Confirmed'){
                fetchcurrentDSR();//Query all the fields again
            }
        }
        return isClassicWizard;
    }
    
    //Start Canvas Flow
    public pagereference startCanvasFlow(){
        if (this.state.dsrId == null) {
            // create new dsr
            try{
                BS_Deal_Support_Request__c dsr = this.state.dsr;
                if(Schema.sObjectType.BS_Deal_Support_Request__c.isAccessible() && Schema.sObjectType.BS_Deal_Support_Request__c.isCreateable()){
                    insert dsr; 
                }
                this.state.dsrId = dsr.Id;
                renderCanvas = true;
            }catch(exception e){
                renderCanvas = false; //Do not render the Canvas Screen
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Processing Failed - ' + e.getMessage()));
            }
        }
        return null;
    }
    
    //Send the Domain for redirection in Canvas App
    public String getCanvasAppDomain(){
        String appDomain;
        string instanceName= ApexPages.currentPage().getParameters().get('instanceName').escapeHtml4();       bsource__BriefingSourceSettingsLists__c bss = bsource__BriefingSourceSettingsLists__c.getValues(instanceName);
       // bsource__BriefingSourceSettings__c  bss = bsource__BriefingSourceSettings__c.getOrgDefaults();
        if(bss.bsource__API_Endpoint__c != null){
            appDomain = bss.bsource__API_Endpoint__c.substringBetween('//','.');
        }
        return appDomain;
    }
    
}