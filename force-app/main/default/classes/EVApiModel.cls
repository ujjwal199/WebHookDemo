/*
 * Model representing API JSON structures
 */ 
public with sharing class EVApiModel {
    // abstraction
    public with sharing virtual class Entity {
        public String id; //1
        public String name; //Topic Category 1
    }
    
    public with sharing virtual class EntitiesResponse {
        public boolean success;
        public Integer count; 
    }
    
   // topics API related classes
    public with sharing class Topic extends Entity{
        public String duration; //95
        public Entity category;
    }    

    public with sharing class TopicsResponse extends EntitiesResponse{
        public Topic[] data;

    }
    
     public with sharing class CalendarDate {
         public String start {get;set;}
         public Boolean available {get;set;}
    }

    
    // sites api response
	public with sharing class Site extends Entity {
        public String perDayBriefingLimit; //4
        public String leadTime; //0
        public SiteTimezone timezone;
        // taking this as map as it conflicts on keyword "end" in JSON attributes
        public Map<String, String> hoursOfOperation;
//        public SiteHoursOfOperation hoursOfOperation;
//        
        public String getStartHoursOfOperation() {
            return hoursOfOperation != null ? hoursOfOperation.get('start') : null;
        }  
        public String getEndHoursOfOperation() {
		return hoursOfOperation != null ? hoursOfOperation.get('end') : null;
        }  

    }
    public with sharing class SiteTimezone {
        public String name; //(UTC-08:00) Baja California
        public String code; //America/Ensenada
    }
//    class SiteHoursOfOperation {
//        public String start; //09:00:00
//        public String end; //17:00:00
//    }
//  
	public with sharing class SitesResponse extends EntitiesResponse{
        public Site[] data;
     }
    
    
    public static SitesResponse parseSites(String json) {
        return (SitesResponse) System.JSON.deserialize(json, SitesResponse.class);
    }
 
    public static TopicsResponse parseTopics(String json) {
        return (TopicsResponse) System.JSON.deserialize(json, TopicsResponse.class);
    }
    

    public static CalendarDate[] parseDates(String json) {
        System.debug(json);
        Map<String, Object> datesMap = (Map<String, Object>)System.JSON.deserializeUntyped(json);
        CalendarDate[] dates = new CalendarDate[]{};
	   for (String datee : datesMap.keySet()) {
        	CalendarDate cd = new CalendarDate();
	        cd.start = datee;
             cd.available = Boolean.valueOf(((Map<String, Object>)datesMap.get(datee)).get('available'));
	        dates.add(cd);
        } 
        return dates;
    }

    public static void testParseDates(){
        String sampleJSON = '{"2015-06-24":{"available":true},"2015-06-25":{"available":true},"2015-06-26":{"available":true},"2015-06-27":{"available":true},"2015-06-28":{"available":true},"2015-06-29":{"available":true},"2015-06-30":{"available":true},"2015-07-01":{"available":true},"2015-07-02":{"available":true},"2015-07-03":{"available":true},"2015-07-04":{"available":true},"2015-07-05":{"available":true},"2015-07-06":{"available":true},"2015-07-07":{"available":true},"2015-07-08":{"available":true},"2015-07-09":{"available":true},"2015-07-10":{"available":true},"2015-07-11":{"available":true},"2015-07-12":{"available":true},"2015-07-13":{"available":true},"2015-07-14":{"available":true},"2015-07-15":{"available":false},"2015-07-16":{"available":true},"2015-07-17":{"available":true},"2015-07-18":{"available":true},"2015-07-19":{"available":true},"2015-07-20":{"available":true},"2015-07-21":{"available":true},"2015-07-22":{"available":true},"2015-07-23":{"available":true},"2015-07-24":{"available":true},"2015-07-25":{"available":true},"2015-07-26":{"available":true},"2015-07-27":{"available":true},"2015-07-28":{"available":true},"2015-07-29":{"available":true},"2015-07-30":{"available":true},"2015-07-31":{"available":true},"2015-08-01":{"available":true},"2015-08-02":{"available":true},"2015-08-03":{"available":true},"2015-08-04":{"available":true},"2015-08-05":{"available":true},"2015-08-06":{"available":true},"2015-08-07":{"available":true},"2015-08-08":{"available":true},"2015-08-09":{"available":true},"2015-08-10":{"available":true},"2015-08-11":{"available":true},"2015-08-12":{"available":true},"2015-08-13":{"available":true},"2015-08-14":{"available":true},"2015-08-15":{"available":true},"2015-08-16":{"available":true},"2015-08-17":{"available":true},"2015-08-18":{"available":true},"2015-08-19":{"available":true},"2015-08-20":{"available":true},"2015-08-21":{"available":true},"2015-08-22":{"available":true},"2015-08-23":{"available":true},"2015-08-24":{"available":true},"2015-08-25":{"available":true},"2015-08-26":{"available":true},"2015-08-27":{"available":true},"2015-08-28":{"available":true},"2015-08-29":{"available":true},"2015-08-30":{"available":true},"2015-08-31":{"available":true},"2015-09-01":{"available":true},"2015-09-02":{"available":true},"2015-09-03":{"available":true},"2015-09-04":{"available":true},"2015-09-05":{"available":true},"2015-09-06":{"available":true},"2015-09-07":{"available":true},"2015-09-08":{"available":true},"2015-09-09":{"available":true},"2015-09-10":{"available":true},"2015-09-11":{"available":true},"2015-09-12":{"available":true},"2015-09-13":{"available":true},"2015-09-14":{"available":true},"2015-09-15":{"available":true},"2015-09-16":{"available":true},"2015-09-17":{"available":true},"2015-09-18":{"available":true},"2015-09-19":{"available":true},"2015-09-20":{"available":true},"2015-09-21":{"available":true},"2015-09-22":{"available":true}}';
        parseDates(sampleJSON);
        
    }
    
    

}