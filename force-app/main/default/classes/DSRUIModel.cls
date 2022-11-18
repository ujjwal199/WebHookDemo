/*
 * Classes representing BS API in a UI friends structure
 */ 
public with sharing class DSRUIModel {
    public with sharing virtual class CalloutDatum {
        public String name {get;set;}        
        public String id {get;set;}    
        // convinence property
        public Boolean selected {get;set;}

        {
            this.selected = false;
        }
        
        public CalloutDatum(String name, String id) {
            this.name = name;
            this.id = id;
        }
    }

    public with sharing class Topic extends CalloutDatum {
        public String apiId    {get;set;}
        public String categoryName {get;set;}
        public String categoryId {get;set;}        
        public String duration {get;set;} 
        public String notes {get;set;}
        public String dsrId {get;set;}
        
        public Topic (String name, String id) {
            super(name, id);
        }
        
        public Topic(Briefing_Topic__c bt) {
        super(bt.Name, bt.Id);
          this.categoryName = bt.Category_Name__c;  
          this.categoryId = bt.Category_Id__c;              
          this.apiId = bt.Topic_Id__c;         
          this.dsrId = bt.Deal_Support_Request__c;
          this.notes = bt.Notes__c;
        }
        
        public Briefing_Topic__c toBriefingTopicRecord() {
          return new Briefing_Topic__c(Id = String.isBlank(this.id) ? null : this.id, 
                                       Name = this.name,
                                       Category_Name__c = this.categoryName,
                                       Category_Id__c = this.categoryId,             
                                       Topic_Id__c = this.apiId,         
                                       Deal_Support_Request__c = this.dsrId,
                                       Notes__c = this.notes
                                      );

        }
    }
    
    public with sharing class Site extends CalloutDatum {
        public String timezone {get;set;}
        public String startHours {get;set;}
        public String endHours {get;set;}
        
        public Site(String id, String name, String timezone, String startHours, String endHours) {
            super(name, id);
            this.timezone = timezone;
            this.startHours = startHours;
            this.endHours = endHours;
        }
        public String getHoursOfOperation() {
            String hop = '';
            if (!String.isBlank(this.startHours) && !String.isBlank(this.endHours)) {
                hop = this.startHours + '  -  ' + this.endHours;
            }
            return hop;
        }
    }
    
    public with sharing class SitesRequest {
        // any params which need to be inputted for loading sites
    }
    
    public with sharing class SitesResponse {
        public Site[] sites {get;set;}
        {
            this.sites = new Site[]{};
        }
    }

    public with sharing class TopicsRequest {
        public String siteId {get;set;}
        // any params which need to be inputted for loading sites
    }
    
    public with sharing class TopicsResponse {
        public Topic[] topics {get;set;}
        {
            this.topics = new Topic[]{};
        }
        
    } 
    
    public with sharing class CalendarItem {
        public String start {get;set;}     
        public Boolean available {get;set;}     
        public Boolean allDay {get;set;}
        {
            this.allDay = true;
        }
        public CalendarItem(String d, Boolean avail) {
            this.start = d;
            this.available = avail;
        }
        
        public CalendarItem(Date d, Boolean avail) {
            this.start = d.year() + '-'+ d.month() + '-' + d.day();
            this.available = avail;
        }
        public String title {
            get {
                return this.available ? 'Available' : 'Reserved';                
            }
        }
        public String backgroundColor {
            get {
                return this.available ? '#B2E0B2' : '#FFBFBF';                
            }
        }
        
    }        
      
    public with sharing class CalendarRequest {
        public String siteId {get;set;}

        // any params which need to be inputted for loading sites
    }
    
    public with sharing class CalendarResponse {
        public CalendarItem[] dates {get;set;}
        {
            this.dates = new CalendarItem[]{};
        }
        
    } 

    public with sharing class CalendarTopicResult {
        public CalendarItem[] dates {get;set;}
        {
            this.dates = new CalendarItem[]{};
        }
        
        public Topic[] topics {get;set;}
        {
            this.topics = new Topic[]{};
        }

    }
    
    // 
    // Start: Helper inner classes 
    //
    public enum WizardStage {
        Site, Topics, Attendees, AddInfo, Review
    }
    
    public with sharing class Attendee {
        public Boolean selected {get;set;}
        public Contact contact {get;set;}
        public String role {get;set;}
        
        public Attendee(Contact contact, String role, Boolean showSelected) {
            this.contact = contact;
            this.role = role;
            this.selected = showSelected;
        }
    }
    
    public with sharing class WizardState {
        public WizardStage stage {get;set;}
          public Id oppId {
            get {
                return ApexPages.currentPage().getParameters().get('Id').escapeHtml4();
            }
        }
        public Opportunity relatedOpportunity {get;set;}
        public Id dsrId {
            get {
                if (dsrId == null) {
                    dsrId = ApexPages.currentPage().getParameters().get('dsrId').escapeHtml4();    
                }
                return dsrId;
            } set;
        }
        public BS_Deal_Support_Request__c dsr {
            get {
                if (dsr == null) {
                    if (this.dsrId == null) {
                        dsr = new BS_Deal_Support_Request__c(Status__c = 'Draft', 
                                                                  Requestor__c = UserInfo.getUserId(),
                                                                  Opportunity__c = oppId);    
                    } else {
                        dsr = [Select Name, Status__c,Briefing_Objective__c,Meeting_Duration__c from BS_Deal_Support_Request__c Where Id =:this.dsrId];
                    } 
                }
                return dsr;
            }
            set;
        }
        
        public String selectedSite {get;set;}
        public String selectedSiteName {get;set;}        
        public String selectedPrimaryDate {get;set;}
        public String selectedAlternateDate {get;set;} 
        public String selectedMeetingDurationType {get;set;} 
        public String selectedStartTime {get;set;} 
        public String selectedEndTime {get;set;} 

       public transient SitesResponse sitesResponse {get;set;}        
        public Attendee[] probableAttendees {get;set;} 
        
        public Briefing_Attendee__c[] adHocAttendees {get;set;}
        
        
        
      
        
        public Boolean isStageTopics {
            get {return stage == WizardStage.Topics;}
        }
        
        public Boolean isStageSite {
            get {return stage == WizardStage.Site;}
        }
        public Boolean isStageAddInfo {
            get {return stage == WizardStage.AddInfo;}
        }        
        
        public Boolean isStageReview {
            get {return stage == WizardStage.Review;}
        }        
        
        public Boolean isStageAttendees {
            get {return stage == WizardStage.Attendees;}
        }
        
        public Boolean canChangeDSRName {
            get {return dsr.Status__c == 'Draft' || dsr.Status__c == 'Updates Required'; }
        }        
        public Boolean canChangeSites {
            get {return dsr.Status__c == 'Draft' || dsr.Status__c == 'Updates Required'; }
        }        
        public Boolean canChangeDates {
            get {return dsr.Status__c == 'Draft' || dsr.Status__c == 'Updates Required'; }
        }        
        public Boolean canChangeTopics {
            get {return dsr.Status__c == 'Draft' || dsr.Status__c == 'Updates Required'; }
        }        
        public Boolean canChangeAddInfo {
            get {return dsr.Status__c == 'Draft' || dsr.Status__c == 'Updates Required'; }
        }                
        public Boolean canChangeAttendees {
            get {return dsr.Status__c != 'Declined' && dsr.Status__c != 'Archived'; }
        }        
        public Boolean canChangeDSR {
            get {return dsr.Status__c != 'Declined' && dsr.Status__c != 'Archived'; }
        }  
           
        public Date getSelectedPrimaryDateObj() {
            return Utils.toDateFromISOString(this.selectedPrimaryDate);
        }

        public Date getSelectedAlternateDateObj() {
            return Utils.toDateFromISOString(this.selectedAlternateDate);
        }
            
    }
}