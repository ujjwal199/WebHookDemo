@RESTResource(urlMapping='/Leaf/')
global without Sharing class CreateLeadApi{
 //post request methord
    @HTTPPost
    global static String doPost(){
        String Fmane,lname,Comp;
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        String JsonBody=req.requestBody.toString();
       JSONparser parser=JSON.createParser(JsonBody);
       System.debug('system running on callout>>');
        
        while(parser.nextToken()!=null){
            if(parser.getCurrentToken()!= null){
                System.debug('name>>'+parser.getCurrentName());
            }
        }
        return 'Hey parser  >>>  Thanks Entered Successfully';
    }
}