@isTest
public class TestDataFactory {
    
    public static Account createAccount(String name, Boolean doInsert){
        
        Account account = new Account();
        account.Name = name;
        
        if(doInsert)
            insert account;
        
        return account;
        
    }
    
    public static Contact createContact(String accountId, String firstName, String lastName, String email, Boolean doInsert){
        
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Email = email;
        contact.AccountId = accountId;
        
        if(doInsert)
            insert contact;
        
        return contact;
        
    }
    
    public static Lead createLead(String companyName, String firstName, String lastName, String email, Boolean doInsert){
        
        Lead lead = new Lead();
        lead.Company = companyName;
        lead.FirstName = firstName;
        lead.LastName = lastName;
        lead.Email = email;
        
        if(doInsert)
            insert lead;
        
        return lead;
        
    }
    
    public static Opportunity createOpportunity(String name, String stage, String accountId, Boolean doInsert){
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = name;
        opportunity.StageName = stage; 
        opportunity.CloseDate = System.today();
        opportunity.AccountId = accountId;
        
        if(doInsert)
            insert opportunity;
        
        return opportunity;
        
    }
    
    public static OpportunityLineItem createOpportunityLineItem(String opportunityId, Boolean doInsert){
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.OpportunityId = opportunityId;
        opportunityLineItem.PricebookEntryId = Test.getStandardPricebookId();
        opportunityLineItem.UnitPrice = 10;
        opportunityLineItem.Quantity = 1;
        
        if(doInsert)
            insert opportunityLineItem;
        
        return opportunityLineItem;
        
    }
    
}