/**
 * @description      : LeadConversionQueueableApex
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
public class LeadConversionQueueableApex implements Queueable {
    
    Map<String,String> mapOfUUIDVsProductQuantity;
    List<Lead> leadList;
    
    public LeadConversionQueueableApex(List<Lead> leadList, Map<String,String> mapOfUUIDVsProductQuantity){
        
        this.leadList = leadList;
        this.mapOfUUIDVsProductQuantity = mapOfUUIDVsProductQuantity;
    }
    
    public void execute(QueueableContext context) {
        
        try{
            
            Set<Id> accountIdsSet = new Set<Id>();
            
            List<Database.LeadConvert> leadConvertsList = new List<Database.LeadConvert>();
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            
            for(Lead eachLead : leadList){
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(eachLead.id);
                leadConvert.setConvertedStatus(convertStatus.MasterLabel);
                leadConvertsList.add(leadConvert);
            }
            
            List<Database.LeadConvertResult> LeadConvertResultList = Database.convertLead(leadConvertsList);
            
            for(Database.LeadConvertResult eachConvertedLead: LeadConvertResultList){
                accountIdsSet.add(eachConvertedLead.getAccountId());
            }
            
            if(!accountIdsSet.isEmpty()){
                List<Opportunity> opportunityList = [Select Id From Opportunity WHERE AccountId IN : accountIdsSet];
                if(!opportunityList.isEmpty()){
                    List<OpportunityLineItem> opportunityLineItemList = OtterAPIUtility.createOpportunityLineItemData(opportunityList[0].Id, mapOfUUIDVsProductQuantity);
                    insert opportunityLineItemList;
                    
                    if(!opportunityLineItemList.isEmpty()){
                        update new opportunity (Id = opportunityList[0].Id, StageName = Constant.closedWonStage);
                    }
                }
            }
            
        }catch(Exception exp){
            System.debug('---exp-> '+exp.getMessage());
        }
        
    }
    
}