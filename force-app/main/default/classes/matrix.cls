public class matrix {
    public static void SEt(){
        List<List<Integer>> L1=new  List<List<Integer>>();
        List<Integer> L2=new  List<Integer>();
         Integer i=1;
         for (Integer K=1;K<=3;K++){
               List<Integer> L3=new  List<Integer>();
             for(Integer j=0;j<3;j++){
                 L3.add(i);
                 i++;
             }
             L1.add(L3);
         }
        //Display
       for(List<Integer>v : L1)
       {
            System.debug(v);
       }
    }
}