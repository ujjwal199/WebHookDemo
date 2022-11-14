@isTest
public class DSRServiceTest {
	@isTest
    static void doGet() {
        String currentNamespace = DSRServiceTest.class.getName().substringBefore('DSRServiceTest').removeEnd('.');
        
        
        RestRequest rr = new RestRequest();
        RestResponse res = new RestResponse();
        rr.requestURI	= '/services/apexrest' + (String.isEmpty(currentNamespace) ? '' : currentNamespace) + '/DSR/v1/a001a0000FooBar';
        
        RestContext.request	= rr;
        RestContext.response = res;
        res = RestContext.response; //Set the response here

        DSRService.doGet();
        System.assertEquals(Null,res.statusCode,'statusCode should be null');
    }
    @isTest
    static void doGet2() {
        String currentNamespace = DSRServiceTest.class.getName().substringBefore('DSRServiceTest').removeEnd('.');
        
        
        RestRequest rr = new RestRequest();
        RestResponse res = new RestResponse();
        rr.requestURI	= '/services/apexrest' + (String.isEmpty(currentNamespace) ? '' : currentNamespace) + '/DSR/v1/';
        
        RestContext.request	= rr;
        RestContext.response = res;
        res = RestContext.response; //Set the response here

        DSRService.doGet();
      //  DSRService.fieldListFromFieldSet(null,'test');
        System.assertEquals(Null,res.statusCode,'statusCode should be null');
    }
}