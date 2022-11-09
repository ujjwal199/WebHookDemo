@RestResource(urlMapping='/api/webhooks/pushDetailsDemo/')
global with sharing class WebHooKSupported {
@HTTPPost
    global static String handleNotification(){
        try{
            RestRequest req=RestContext.request;
            RestResponse res=RestContext.response;
            
            
        }catch(Exception e){
            System.debug('exception>>>>'+e);
        }
        return 'Successfully added';   
        //this should be on the webhook-dev branch
    }
}