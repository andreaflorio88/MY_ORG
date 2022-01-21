/**
* Author        : Andrea Florio
* Created       : 2019-05-13
* Description   : Create Peron account REST Service for PRONTO
* Test Class    : WS_CreateAccountFromDL_Pronto
**/
@RestResource (urlMapping = '/CreateUser/*' )
global class WS_CreateUser{
    
    private static final String TIMEZONESIDKEY = 'Europe/Rome'; // TimeZoneSidKey
    private static final String LOCALKEY = 'IT'; 				// LocaleSidKey - LanguageLocaleKey
    private static final String EMAILENCODINGKEY = 'ISO-8859-1';// EmailEncodingKey
    public class InvalidRequestException extends Exception{}
    
    global class Request {
        global List<UserDetail> dettagliUser;
    }
    global class UserDetail {
        global string FirstName;			    
        global string LastName;				
        global string Username;				
        global string Email;					
        global boolean IsActive;				
        global string Alias;					
        global Id ProfileId;					
        global string EmailEncodingKey; 		
        global string FederationIdentifier;	
        global string TimeZoneSidKey;		
        global string LocaleSidKey;			
        global string LanguageLocaleKey;		
    }
    
    global class Response {
        global List<Map<String,String>> responses;
        global Boolean hasError{get;Set;}
        
        public Response(){
            hasError = false;
            responses = new List<Map<String,String>>();
        }   
    }
    @httpPost
    global static Response createUserService(Request request) {
        Response response = new Response();
        try {
            List<UserDetail> userList = new List<UserDetail>();
            List<User> userToInsert = new List<User>();
            List<UserDetail> userToUpdate = new List<UserDetail>();
            //BUILD SET USERNAME FOR DUPLICATE RULE
            Set<String> userName = new Set<String>();
            
            for(Userdetail  du : request.dettagliUser){
                Map<String, String> errorResponseMap = checkMandatoryFieldError(du);
                if (errorResponseMap != null) {
                    response.hasError = true;
                    response.responses.add(errorResponseMap);
                } else {
                    //Set strutture dati per record not in error
                    du.Alias = buildAlias(du);
                    userName.add(du.UserName);
                    System.debug('@@@UserName: '+ userName);
                    userList.add(du);
                }
            }
            
            //------------------------------------------------------------------------------------------------//
            //------------------------------ 1. Check Existing User in DB ------------------------------------//
            //------------------------------------------------------------------------------------------------//            
            
            // Map Username-User to Manage Duplicate
            Map<String,User> userIdToUpdate = new Map<String,User>();
            List<User> userDuplicate = [SELECT Id, userName FROM User WHERE Username IN: userName];
            for(User userInUpdate: userDuplicate){
                userIdToUpdate.put(userInUpdate.userName, userInUpdate);
            }
            for(userDetail checkDupl: userList){
                String userNameToCheck = checkDupl.userName;
                if(userIdToUpdate.containskey(userNameToCheck)){
                    userToUpdate.add(checkDupl);
                    System.debug('@@@userToUpdate: '+ userToUpdate);
                } else {
                    userToInsert.add(buildUser(checkDupl));
                    System.debug('@@@userToInsert: '+ userToInsert);
                }
            }
            if(!userToInsert.isEmpty()){
                Map<String,String> successResponseMap = New Map<String,String>();
                for(User us: userToInsert){
                    Database.DMLOptions dml = new Database.DMLOptions();
                    dml.EmailHeader.triggerUserEmail = true;
                    database.insert(userToInsert, dml);
                    buildResponse(us, false);
                    response.responses.add(successResponseMap); 
                }
            }
            
        } catch(Exception ex){
            System.debug('^^ERROR Catched: '+ex.getMessage());
            System.debug('^^ST: '+ex.getStackTraceString());
            Map<String,String> errorResponseMap = new Map<String,String>();
            response.hasError = true;
            errorResponseMap.put('result','FAILED');
            errorResponseMap.put('id','');
            errorResponseMap.put('operationType','Catched System Error');
            errorResponseMap.put('resultMessage','Catched System Error: '+ex.getMessage());
            response.responses.add(errorResponseMap);
        }
        return response;
    }
    
    private static Map<String,String> checkMandatoryFieldError(UserDetail du){
        Map<String,String> errorResponseMap = null;
        if (String.isBlank(du.LastName) || String.isBlank(du.Username) || string.isBlank(du.Email) ||
            String.isBlank(du.ProfileId) || du.IsActive==null) {
                errorResponseMap = new Map<String,String>(); 
                errorResponseMap.put('result','FAILED');
                errorResponseMap.put('operationType','ValidationField');
                //errorResponseMap.put('id','');
            }
        if(String.isBlank(du.LastName)) {
            System.debug('@!@LastName error');
            errorResponseMap.put('resultMessage','LastName mandatory field');
            errorResponseMap.put('Lastname','null');
        } else if (String.isBlank(du.Username)) {
            System.debug('@!@Username error');
            errorResponseMap.put('resultMessage','UserName mandatory field');
            errorResponseMap.put('Lastname',du.LastName);
        }   else if (String.isBlank(du.Email)) {
            System.debug('@!@Email error');
            errorResponseMap.put('resultMessage','Email mandatory field');
            errorResponseMap.put('Username',du.Username);
        }   else if (String.isBlank(du.ProfileId)) {
            System.debug('@!@ProfileId error');
            errorResponseMap.put('resultMessage','ProfileId mandatory field');
            errorResponseMap.put('Username',du.Username);  
        }   else if (du.IsActive == null) {
            System.debug('@!@IsActive error');
            errorResponseMap.put('resultMessage','Active mandatory field');
            errorResponseMap.put('Username',du.Username);
        }
        return errorResponseMap;
    }
    private static String buildAlias(UserDetail du){
        String alias;
        alias = du.FirstName.substring(0,1) + du.LastName.substring(0,3);
        return alias;
    }
    private static User buildUser(UserDetail du){
        User userToInsert = new User();
        if(du.FirstName!=null) 				userToInsert.FirstName = du.FirstName;
        if(du.FederationIdentifier.equals(du.Username)) {
            userToInsert.FederationIdentifier = du.FederationIdentifier;
        } else {
            throw new InvalidRequestException('Username and FederationIdentifier must be the same');
        }
        userToInsert.Lastname = du.Lastname;			
        userToInsert.Username = du.Username; 			
        userToInsert.Email = du.Email;				
        userToInsert.IsActive	= du.IsActive;			
        userToInsert.Alias = du.Alias;	
        userToInsert.ProfileId = du.ProfileId;
        userToInsert.EmailEncodingKey = EMAILENCODINGKEY;						
        userToInsert.TimeZoneSidKey = TIMEZONESIDKEY;
        userToInsert.LocaleSidKey = LOCALKEY;
        userToInsert.LanguageLocaleKey = LOCALKEY; 
        return userToInsert;
    }
    
    public static Map<String,String> buildResponse(User du, boolean isUpdate){
        Map<String,String> successResponseMap = New Map<String,String>();
        successResponseMap.put('Usermame',du.Username);
        if(isUpdate){
            successResponseMap.put('operationType','Update');
            successResponseMap.put('result','SUCCESS');
            successResponseMap.put('resultMessage','Updated Record with Id: '+ du.Id);
            successResponseMap.put('id',du.id);  
        }
        if(!isUpdate){
            successResponseMap.put('operationType','Insert');
            successResponseMap.put('result','SUCCESS');
            successResponseMap.put('resultMessage','Inserted Record with Id: '+ du.Id);
            successResponseMap.put('id',du.id);
        }
        return successResponseMap;
    }


    /*
    {
    "request": {
        "dettagliUser": [{
                "FirstName": "Dcs",
                "LastName": "Customer",
                "UserName":"test",
                "Email":"test@test.com",
                "ProfileId":"",
                "isActive": false
            }]
        }
    }
    */
}