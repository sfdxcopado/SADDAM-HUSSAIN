/**
 * @description      : AccountTrigger
 * @author           : Saddam Hussain
 * @last modified on : 19-12-2022
 * @last modified by : Saddam Hussain
 * Ver    Date    		Author  		Modification
 * 1.0  16-12-2022     Saddam Hussain  Initial Version 
**/
trigger AccountTrigger on Account (before insert) {

	AccountTriggerHandler.HandleDuplicateAccount(trigger.new);    
}