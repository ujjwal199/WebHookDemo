@isTest
private class EVApiModel_Test {
    static testMethod void testParseTopics() {
        String json = '{"success":true,"count":4,"data":[{"id":"2","name":"Generic Medicines","duration":"95","category":{"id":"1","name":"Topic Category 1"}},{"id":"3","name":"AppExchange","duration":"5","category":{"id":"2","name":"Topic Category 2"}},{"id":"4","name":"ISVs","duration":"90","category":{"id":"2","name":"Topic Category 2"}},{"id":"5","name":"Custom Development on Salesforce","duration":"45","category":{"id":"1","name":"Topic Category 1"}}]}';
        EVApiModel.TopicsResponse obj = EVApiModel.parseTopics(json);
        System.assert(obj != null,'obj should not null');
    }    

    static testMethod void testParseSites() {
        String json = '{"success":true,"count":1,"data":[{"id":"1","name":"Mt. View, CA, USA","perDayBriefingLimit":"4","leadTime":"0","timezone":{"name":"(UTC-08:00) Baja California","code":"America Ensenada"},"hoursOfOperation":{"start":"09:00:00","end":"17:00:00"}}]}';
        EVApiModel.SitesResponse obj = EVApiModel.parseSites(json);
        EVApiModel.Site objSite = new EVApiModel.Site();
        objSite.getEndHoursOfOperation();
        objSite.getStartHoursOfOperation();
        
        System.assert(obj != null,'obj should not null'); 
    }

}