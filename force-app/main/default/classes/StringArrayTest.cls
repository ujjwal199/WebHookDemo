public class StringArrayTest{
    public static List<String> generateStringArray(Integer Len){
     List<String> testList=new List<String>();
        
        for( Integer i=0;i<Len;i++)
      {
testList.add('Test'+' '+i);
      }
return testList; 
    }
    
}