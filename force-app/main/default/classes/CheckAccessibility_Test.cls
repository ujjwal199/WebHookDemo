@isTest
public class CheckAccessibility_Test {
   
    public static testMethod void testMethod1(){
        
        CheckAccessibility.isAccessible('FirstName, LastName','contact');
        CheckAccessibility.isInsertable('FirstName, LastName' ,'contact');
        CheckAccessibility.isUpdateable('FirstName, LastName' ,'contact');
        Boolean deletebaleContactPermission = CheckAccessibility.isDeletable('contact');
        Boolean upsertableContactPermission = CheckAccessibility.isUpsertable('FirstName, LastName' ,'contact');
        
        system.assertEquals(true, deletebaleContactPermission,'deletebaleContactPermission should be true');
        system.assertEquals(true, upsertableContactPermission,'upsertableContactPermission should be true');
        
        
        
    }
    
}