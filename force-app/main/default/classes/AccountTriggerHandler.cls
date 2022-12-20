/**
 * @description      : AccountTriggerHandler
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
public class AccountTriggerHandler {

    public static void HandleDuplicateAccount(List<Account> accountList){
        
        Set<String> accountNameSet = new Set<String>();
        
        for(Account eachAccount : accountList){
            accountNameSet.add(eachAccount.Name);
        }
        
        Map<String, Lead> mapOfLeadNameVsLead = new Map<String, Lead>();
        
        for(Lead eachLead : [Select Id, Company From Lead where Company IN : accountNameSet AND IsConverted = false]){
            mapOfLeadNameVsLead.put(eachLead.Company, eachLead);
        }
        
        for(Account eachAccount : accountList){
            if(mapOfLeadNameVsLead.containsKey(eachAccount.Name)){
                eachAccount.addError('You can not create duplicate account. Already lead is created with the same name.');
            }
        }
        
    }
    
}