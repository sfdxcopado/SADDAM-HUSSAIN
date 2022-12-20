/**
 * @description      :
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
public with sharing class OtterAPIUtility {
    
    private static Account account;
    private static Contact contact;
    private static Opportunity opportunity;
    private static List<OpportunityLineItem> opportunityLineItemList;
    
    
    //This method will return the Account
    public static List<Account> getAccountData(String companyName){
        
        List<Account> accountList = new List<Account>();
        
        try{
            accountList = [SELECT Id, Name FROM Account WHERE Name =: companyName];
        }catch(Exception exp){
            System.debug('---exp-> '+exp.getMessage());
        }
        
        return accountList;
        
    }
    
    //This method will return the Lead
    public static List<Lead> getLeadData(String companyName){
        
        List<Lead> leadList = new List<Lead>();
        
        try{
            leadList = [Select Id, Company From Lead Where Company =: companyName AND IsConverted = false];
        }catch(Exception exp){
            System.debug('---exp-> '+exp.getMessage());
        }
        
        return leadList;
        
    }
    
    //This method will return the PricebookEntry
    public static List<PricebookEntry> getPricebookEntryData(Set<String> productUUIDList){
        
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
        
        try{
            pricebookEntryList = [SELECT Id, Product2Id, UnitPrice, IsActive, ProductCode, Product2.ProductCode FROM PricebookEntry Where Product2.ProductCode IN : productUUIDList];
        }catch(Exception exp){
            System.debug('---exp-> '+exp.getMessage());
        }
        
        return pricebookEntryList;
        
    }
    
    public static void createData(Map<String, Object> mapOfObject, Map<String,String> mapOfUUIDVsProductQuantity){
        
        try{
            String companyName = (String)mapOfObject.get(Constant.companyName);
            String phone = (String)mapOfObject.get(Constant.phone);
            String email = (String)mapOfObject.get(Constant.email);
            String firstName = (String)mapOfObject.get(Constant.firstName);
            String lastName = (String)mapOfObject.get(Constant.lastName); 
            
            account = createAccountData(companyName, phone);
            insert account;
            
            if(String.isNotBlank(account.Id)){
                
                createContactData(firstName, lastName, phone, email, account.Id);
                
                opportunity = createOpportunityData(companyName, account.Id);
                insert opportunity;
                
                if(String.isNotBlank(opportunity.Id)){
                    
                    opportunityLineItemList = createOpportunityLineItemData(opportunity.Id, mapOfUUIDVsProductQuantity);
                    insert opportunityLineItemList;
                    
                    if(!opportunityLineItemList.isEmpty()){
                        update new opportunity (Id = opportunity.Id, StageName = Constant.closedWonStage);
                    }
                    
                }
            }
        }catch(DMLException exp){
            System.debug('---exp-> '+exp.getMessage());
        }
        
    }
    
    public static Account createAccountData(String name, String phone){
        
        Account account = new Account();
        account.Name = name;
        account.Phone = phone;
        
        return account;
        
    }
    
    public static Contact createContactData(String firstName, String lastName, String phone, String email, String accountId){
        
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Phone = phone;
        contact.Email = email;
        contact.AccountId = accountId;
        
        return contact;
        
    }
    
    public static Opportunity createOpportunityData(String name, String accountId){
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = name;
        opportunity.AccountId = accountId;
        opportunity.CloseDate = Constant.today;
        opportunity.StageName = Constant.prospectingStage;
        
        return opportunity;
        
    }
    
    public static List<OpportunityLineItem> createOpportunityLineItemData(String opportunityId, Map<String,String> mapOfUUIDVsProductQuantity){
        
        List<PricebookEntry> pricebookEntryList = getPricebookEntryData(mapOfUUIDVsProductQuantity.keySet());
        
        List<OpportunityLineItem> opportunityLineItemList = new List<OpportunityLineItem>();
        
        if(!pricebookEntryList.isEmpty()){
            
            for(PricebookEntry eachPriceBookEntry : pricebookEntryList){
                if(mapOfUUIDVsProductQuantity.containsKey(eachPriceBookEntry.Product2.ProductCode)){
                    OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
                    opportunityLineItem.OpportunityId = opportunityId;
                    opportunityLineItem.PricebookEntryId = eachPriceBookEntry.Id;
                    opportunityLineItem.UnitPrice = eachPriceBookEntry.UnitPrice;
                    opportunityLineItem.Quantity = Decimal.valueOf(mapOfUUIDVsProductQuantity.get(eachPriceBookEntry.Product2.ProductCode));
                    opportunityLineItemList.add(opportunityLineItem);
                }
            }
            
        }
        
        return opportunityLineItemList;
        
    }
    
}