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
     public static testMethod void testMethod12(){
        
        CheckAccessibility.isAccessible('FirstNamse, LastNsame','constact');
        CheckAccessibility.isInsertable('FirstNamse, LastNsame' ,'cosntact');
        CheckAccessibility.isUpdateable('FirstNamse, LastNsame' ,'constact');
        Boolean deletebaleContactPermission = CheckAccessibility.isDeletable('contacst');
        Boolean upsertableContactPermission = CheckAccessibility.isUpsertable('FirstNsame, LastNsame' ,'csontact');
        
      //  system.assertEquals(true, deletebaleContactPermission,'deletebaleContactPermission should be true');
     //   system.assertEquals(true, upsertableContactPermission,'upsertableContactPermission should be true');
      
    }
     public static testMethod void testMethod2(){
        
        CheckAccessibility.isAccessible('FirstNamse, LastNsame','constact');
        CheckAccessibility.isInsertable('FirstNamse, LastNsame' ,'cosntact');
        CheckAccessibility.isUpdateable('FirstNamse, LastNsame' ,'constact');
        Boolean deletebaleContactPermission = CheckAccessibility.isDeletable(null);
        Boolean upsertableContactPermission = CheckAccessibility.isUpsertable('','');
        
       // system.assertEquals(true, deletebaleContactPermission,'deletebaleContactPermission should be true');
       // system.assertEquals(true, upsertableContactPermission,'upsertableContactPermission should be true');
       
    }
    
    
}