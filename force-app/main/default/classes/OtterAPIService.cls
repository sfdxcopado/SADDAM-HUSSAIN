/**
 * @description      : OtterAPIServic calss
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
@RestResource(urlMapping='/OtterAPI/*')
global class OtterAPIService {
    
    @HttpPost
    global Static String handlePost(){
        
        String status;
        try{ 
            
            List<Account> accountList = new List<Account>();
            List<Lead> leadList = new List<Lead>();
            
            RestRequest request = Restcontext.request;
            System.debug('---request-> '+request.requestBody);
            System.debug('---requestBody---> '+request.requestBody.toString());
            Map<String, Object> mapOfObject = ( Map<String, Object> )JSON.deserializeUntyped( request.requestBody.toString() );
            System.debug('mapOfObject-> '+mapOfObject);
            System.debug('ProductList-> '+mapOfObject.get(Constant.productList));
            String companyName = (String)mapOfObject.get(Constant.companyName);
            accountList = OtterAPIUtility.getAccountData(companyName);
            leadList = OtterAPIUtility.getLeadData(companyName);
            List<Object> productList = (List<Object>)mapOfObject.get(Constant.productList);
            Map<String,String> mapOfUUIDVsProductQuantity = new Map<String,String>();
            for(object eachRecord : productList){
                Map<String, Object> mapOfProduct = ( Map<String, Object> )eachRecord;
                mapOfUUIDVsProductQuantity.put((String)mapOfProduct.get(Constant.productUUID), (String)mapOfProduct.get(Constant.productQuantity));
            }
            System.debug('mapOfUUIDVsProductQuantity-> '+mapOfUUIDVsProductQuantity);
            
            if(!leadList.isEmpty()){
                //Lead conversion logic here
                Id jobId = System.enqueueJob(new LeadConversionQueueableApex(leadList, mapOfUUIDVsProductQuantity));
                status = 'Successful';
            }else if(accountList.isEmpty()){
                //Manually create the record
                OtterAPIUtility.createData(mapOfObject, mapOfUUIDVsProductQuantity);
                status = 'Successful';
            }
            
        }catch(Exception exp){
            System.debug('---exp-> '+exp.getMessage());
            status = 'Failed';
        }
        
        return status;
        
    }
    
}