trigger ContactWithSingleAccount on Contact (before insert) {
    List<Contact> conlist= new List<Contact>();
    
    For(Contact con: trigger.new){
        try{
           conlist=[Select LastName,Id,Email From Contact Where AccountId=:con.AccountId]; 
            if(conlist.size()>0 && conlist!=null){
                System.debug('error can not insert');
               con.addError('You cant insert this record.');
            }
        }catch(Exception ex)
        {
            System.debug('ex>>'+ex);
        }
       
        
    }

}