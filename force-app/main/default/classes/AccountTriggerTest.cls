/**
 * @description      : Test class for AccountTrigger
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
@isTest
public class AccountTriggerTest {
    
    @testSetup 
    public static void dataSetup() {
      
        Account account = TestDataFactory.createAccount('UnitTest Account', true);
        
        Lead lead = TestDataFactory.createLead('UnitTest Lead', 'John', 'Dow', 'unit@test.com', true);
               
    }
    
    @isTest 
    public static void accountTrigger() {
        
        Account account = [Select Id, Name From Account limit 1];
        System.assertEquals('UnitTest Account', account.Name, 'Account is created.');
    }
    
}