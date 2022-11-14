@isTest
public class MetadataServiceTest {
    
    @istest public static void test1(){
        MetadataService metadataServiceObj = new MetadataService();
        MetadataService.RemoteSiteSetting objRemoteSiteSetting = new MetadataService.RemoteSiteSetting();
        MetadataService.createResponse_element objcreateResponse_element = new MetadataService.createResponse_element();
        MetadataService.MetadataPort objMetadataPort = new MetadataService.MetadataPort();
        MetadataService.AsyncResult objAsyncResult = new MetadataService.AsyncResult();
        List<MetadataService.AsyncResult> objAsyncResultList = new List<MetadataService.AsyncResult>();
        objMetadataPort.create(null);
        objAsyncResultList = objMetadataPort.checkStatus(null);
       
        MetadataService.checkStatus_element objcheckStatus_element = new MetadataService.checkStatus_element();
        MetadataService.checkStatusResponse_element objcheckStatusResponse_element = new MetadataService.checkStatusResponse_element();
        MetadataService.PackageTypeMembers objPackageTypeMembers = new MetadataService.PackageTypeMembers();
        MetadataService.DebuggingHeader_element objDebuggingHeader_element = new MetadataService.DebuggingHeader_element();
        MetadataService.LogInfo objLogInfo = new MetadataService.LogInfo();
        MetadataService.Metadata objMetadata = new MetadataService.Metadata();
        MetadataService.SessionHeader_element objSessionHeader_element = new MetadataService.SessionHeader_element();
        MetadataService.retrieveResponse_element objretrieveResponse_element = new MetadataService.retrieveResponse_element();
        MetadataService.DebuggingInfo_element objDebuggingInfo_element = new MetadataService.DebuggingInfo_element();
        MetadataService.CallOptions_element objCallOptions_element = new MetadataService.CallOptions_element();
        MetadataService.checkDeployStatus_element objcheckDeployStatus_element = new MetadataService.checkDeployStatus_element();
        MetadataService.create_element objcreate_element = new MetadataService.create_element();
        System.assertEquals(objAsyncResultList,null);
    }
}