@RestResource(urlMapping='/Cases/*')
global class CaseManager {
    
    global class Response {
        global String MessageDescription{get;set;}	
    }
    global class Request {
        global List<DetailsCase> cases{get;set;} 
    }
    global class DetailsCase {    
        global String subject{get;set;}
        global String status{get;set;}
        global String origin{get;set;}
        global String priority{get;set;}
    }
    
    @HttpPost
    global static Response createCase(Request request) {
        Response response = new response();
        for(DetailsCase  dp : request.cases){
            if (String.isBlank(dp.subject)) { 
                response.MessageDescription= 'ERROR: Subject mandatory';               
            } else {
                Case casNew = new Case();
                casNew.Subject =  dp.subject;
                casNew.Status =  dp.status;
                casNew.Origin =  dp.origin;
                casNew.Priority =  dp.priority;
                insert casNew;
                response.MessageDescription = 'insert case with Id: '+ casNew.id; 
                } 
        }   return response; 
    }
}


/*
/services/apexrest/Cases/*

{"request":{ "cases": [{
  "subject" : "",
  "status" : "New",
  "origin" : "Phone",
  "priority" : "Low"
}]}}
*/