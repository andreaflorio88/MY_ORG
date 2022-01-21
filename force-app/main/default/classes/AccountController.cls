/**
 * @File Name          : AccountController.cls
 * @Description        : 
 * @Author             : Andrea Florio
 * @Group              : 
 * @Last Modified By   : Andrea Florio
 * @Last Modified On   : 30/1/2020, 14:55:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/1/2020   Andrea Florio     Initial Version
**/
public with sharing class AccountController {
        public static List<Account> getAllActiveAccounts() {
        return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
        }
}