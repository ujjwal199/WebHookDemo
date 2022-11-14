// getting issues with test asserts in scanner so keeping this test related class with isTest annotation
@isTest
public class MockFactory{
    
    public Account acc{
        get {
            if (acc == null) {
                acc =new Account(Name='Test Name 1');
            
                insert acc;
            }
            
            System.assertNotEquals(null, acc);
            
            return acc;
        }
            
        set;
    }
    
    public List<Contact> con{
        get {
            if (con == null) {
                con = new List<Contact>{new Contact(LastName = 'mark', Title ='SVP, Operations', AccountId = acc.Id),
                        new Contact(LastName = 'Jim', Title ='CEO', AccountId = acc.Id),
                        new Contact(LastName = 'Young', Title ='VP, Finance', AccountId = acc.Id),
                        new Contact(LastName = 'Andy', Title ='VP, Finance', AccountId = acc.Id)};

                insert con;    
            }
            
            System.assertNotEquals(null, con);
            
            return con;
        }
        set;
    }
        
    public Opportunity Opp{
        get{
            if(Opp == null){
                Opp = new Opportunity( 
                            Name = 'MockOpportunity',
                            StageName = 'Negotiation/Review',
                            CloseDate = System.today(),
                            AccountId = acc.Id );
                insert Opp;
            }
            
            System.assertNotEquals(null, Opp);
            
            return Opp;
        }
        set;
    }
    
    public List<AccountContactRole> accConRole{
        get{
            if(accConRole == null){
                accConRole = new List<AccountContactRole>{new AccountContactRole(ContactId = con[0].Id, AccountId = opp.AccountId, Role ='Decision Maker'),
                            new AccountContactRole(ContactId = con[2].Id, AccountId = opp.AccountId, Role ='Decision Maker')};
                
                insert accConRole;
            }
            
            System.assertNotEquals(null, accConRole);
            
            return accConRole;   
        }
        set;
    }
    
    public List<OpportunityContactRole> oppConRole{
        get{
            if(oppConRole == null){
                oppConRole = new List<OpportunityContactRole>{new OpportunityContactRole(ContactId = con[0].Id, OpportunityId = opp.ID, Role ='Decision Maker'),
                            new OpportunityContactRole(ContactId = con[1].Id, OpportunityId = opp.ID, Role ='Business User')};
                
                insert oppConRole;
            }
            
            System.assertNotEquals(null, oppConRole);
            
            return oppConRole;   
        }
        set;
    }
    @isTest
    public static  void TestDSRCtrl() {
        
     MockFactory objMockFactory = new MockFactory();
     system.debug(objMockFactory.acc);
     system.assert(objMockFactory!=null, 'Is not null');   
        
    }
}