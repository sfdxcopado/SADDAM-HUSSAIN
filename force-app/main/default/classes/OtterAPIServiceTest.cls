/**
 * @description      : Test class for OtterAPIService
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
@isTest
public class OtterAPIServiceTest {
    
    @testSetup 
    public static void dataSetup() {
        
        Account account = TestDataFactory.createAccount('UnitTest Account', true);
        
        Lead lead = TestDataFactory.createLead('UnitTest Lead', 'John', 'Dow', 'unit@test.com', true);
        
        Opportunity opportunity = TestDataFactory.createOpportunity('UnitTest Opportunity', Constant.prospectingStage, account.Id, true);
        
    }
    
    @isTest
    public static void createDataManually(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/OtterAPI/';       
        String jsonData = '{ "Company Name" : "Otter", "Email" : "", "Phone" : "", "Address" : "XYZ", "Personal First Name" : "Saddam", "Personal Last Name" : "Hussain", "ProductList" : [ { "Product UUID" : "13pro", "Product Quantity" : "12" }, { "Product UUID" : "14Pro", "Product Quantity" : "87" } ] }';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OtterAPIService.handlePost();
        Test.stopTest();
        
    }
    
    @isTest
    public static void leadConversion(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/OtterAPI/';       
        String jsonData = '{ "Company Name" : "UnitTest Lead", "Email" : "", "Phone" : "", "Address" : "XYZ", "Personal First Name" : "Saddam", "Personal Last Name" : "Hussain", "ProductList" : [ { "Product UUID" : "13pro", "Product Quantity" : "12" }, { "Product UUID" : "14Pro", "Product Quantity" : "87" } ] }';
        req.requestBody = Blob.valueof(jsonData);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OtterAPIService.handlePost();
        Test.stopTest();
        
    }
    
}