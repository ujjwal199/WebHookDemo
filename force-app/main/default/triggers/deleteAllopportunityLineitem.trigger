trigger deleteAllopportunityLineitem on Opportunity (after update) {
  for( Id OopId : Trigger.newMap.keySet() )
{
  if( Trigger.oldMap.get( OopId ).StageName != Trigger.newMap.get( OopId ).StageName )
  {
     List<OpportunityLineItem> L1=[SELECT Id From OpportunityLineItem Where OpportunityId=:OopId];
      if(L1.size()>0 &&L1!=null){
          try{
              delete L1;
              System.debug('Deleted Successfully');              
             }catch(Exception ex){
              System.debug('ex>>'+ex);
              }
      }
      else{System.debug('No record Found');}
  }
}
}