@RestResource(urlMapping='/zinrelo')
global without sharing class ZinreloWebhook {
    @HttpPost
    global static string createDataInSalesforce() {
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            System.debug('req----------->'+req.requestBody);
            System.debug('res----------->'+res.responseBody);
            Map<String,Object> jsonParsed =(Map<String,Object> ) JSON.deserializeUntyped(req.requestBody.toString());
            return req.requestBody.toString();
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return 'error';
        }
    }
}