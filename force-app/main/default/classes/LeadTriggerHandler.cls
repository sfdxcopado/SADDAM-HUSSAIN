/**
 * @description      : LeadTriggerHandler
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
public class LeadTriggerHandler {

    public static void HandleDuplicateLead(List<Lead> leadList){
        
        Set<String> leadCompanyNameSet = new Set<String>();
        
        for(Lead eachLead : leadList){
            leadCompanyNameSet.add(eachLead.Company);
        }
        
        Map<String, Account> mapOfLeadNameVsLead = new Map<String, Account>();
        
        for(Account eachAccount : [Select Id, Name From Account where Name IN : leadCompanyNameSet]){
            mapOfLeadNameVsLead.put(eachAccount.Name, eachAccount);
        }
        
        for(Lead eachLead : leadList){
            if(mapOfLeadNameVsLead.containsKey(eachLead.Company)){
                eachLead.addError('You can not create duplicate lead. Already account is created with the same name.');
            }
        }
        
    }
    
}