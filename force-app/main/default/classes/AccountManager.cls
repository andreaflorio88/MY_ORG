@RestResource(urlMapping='/Accounts/*/contacts')
global class AccountManager {
	
    @HttpGet
    global static Account getAccount(){
        Restrequest request = RestContext.request;
        String accountId = request.requestURI.substringBetween('Accounts/','/contacts');
        Account[] acc = [SELECT Id, Name,(SELECT Id, Name FROM Contacts) FROM Account WHERE Id =:accountId];
        
        return acc.isEmpty() ? null : acc[0];
    }
}