({
    /*Acquisizione della descrizione del case; nel caso in cui
     * la richiesta sia originata da mail, viene recuperata la mail
     * originaria */
    getCaseObject : function(component, event) {

        var getCaseObject = component.get("c.getCase");

        getCaseObject.setParams({
            "caseId": component.get("v.recordId")
        });

        getCaseObject.setCallback(this, function(response) {

            var state = response.getState();

            if(state === "SUCCESS") {

                var caseObj = response.getReturnValue();

                component.set("v.Subject", caseObj.Subject);

                if(caseObj.Origin == 'Phone' || caseObj.Origin == 'Web' || caseObj.Origin == 'Chat' || caseObj.IdProtocollo__c != null){
                    component.set("v.showDescription", true);
                    component.set("v.Description", caseObj.Description);
                }
                else if(caseObj.Origin.includes('Email'))
                    this.getFirstMail(component, event);
            }
        });

        $A.enqueueAction(getCaseObject);
    },

    /* Acquizione della mail di creazione del case */
    getFirstMail : function(component, event) {

        var getMailBody = component.get("c.getHTMLMail");

        getMailBody.setParams({
            "caseId": component.get("v.recordId")
        });

        getMailBody.setCallback(this, function(response) {

            var state = response.getState();


            /* Sostituzione delle classi CSS settate per il corpo della mail;
             * avrebbero valenza anche per altri componenti */
            if(state === "SUCCESS")
                if(response.getReturnValue())
                    component.set("v.htmlBody", this.sanitize(response.getReturnValue()));
        });

        $A.enqueueAction(getMailBody);
    },

    /* Funzione base di sanitizzazione html (css) */
    sanitize : function(htmlString) {

        var sanitizedHtmlString = htmlString.replace("a:link", "ab:link")
        				.replace("a:visited", "ab:visited")
        				.replace(/color:/gi, "")
                        .replace(/h1/gi, "")
                        .replace(/h2/gi, "")
                        .replace(/font-family:/gi, "")
        				.replace(/font-style:/gi, "")
        				.replace(/font-size:/gi, "")
                        .replace(/<base.*[\s]*href=.*>[\s]*</gi, "<")
        				.replace(/<base.*[\s]*href=.*\/>/gi, "")
                        .replace(/"file:\/.*"/gi, "\"\"")
                        .replace(/xmlns.*[\s]*".*[\s]*"/gi, "");

        return sanitizedHtmlString;
    }

})