public without sharing class CouponController {
    
    public Boolean showThankYouPage         {get;set;}
    public String URL_ERROR_PAGE            {get;set;}
    public String answer					{get;set;}
    public Coupon__c coupon					{get;set;}
    public final String ROOT_SITE_CMT_NAME = 'RootSiteError';
    
    
    public CouponController() {
  
        showThankYouPage = false;
    }
    
    
    public PageReference showPage() {
        String currentId = apexpages.currentPage().getparameters().get('Id');
        PageReference pageRef;
        try {
            String valueId = EncodingUtil.base64Decode(currentId).toString();
            System.debug('@@@AccountId  =' + valueId);    
            List<Coupon__c> coupons =  [select id, Risposta__c from Coupon__c where Account__c =: valueId];
            coupon = coupons.get(0);  
            if(coupons!= null)  {
                showThankYouPage = (coupon.Risposta__c!= null ? true : false);
            } else {
                pageRef = new PageReference(URL_ERROR_PAGE);
                pageRef.setRedirect(true);
                return ApexPages.currentPage();
            }
        } 
        catch (Exception e){
            System.debug('CouponController exception : ' + e.getMessage() + ' | ' + e.getStackTraceString() ) ;
            pageRef = new PageReference(URL_ERROR_PAGE);
            pageRef.setRedirect(true);
        }    
        return pageRef;
    } 
    
    
    public PageReference submitAnswer(){
        String currentId = apexpages.currentPage().getparameters().get('Id');
        PageReference pageRef;
        try {
            String valueId = EncodingUtil.base64Decode(currentId).toString();
            System.debug('@@@AccountId  =' + valueId);  
            List<Coupon__c> couponsList =  [select id, Risposta__c from Coupon__c where Account__c =: valueId];
             
            if(couponsList!= null && !String.isBlank(answer)){
				coupon = couponsList.get(0);
                coupon.Risposta__c= answer;
                update couponsList;
                showThankYouPage = true;
                
            } else {
                pageRef = new PageReference('https://www.google.com');
                pageRef.setRedirect(true);
            }
            
        } catch (Exception e){
            System.debug('CouponController exception : ' + e.getMessage() + ' | ' + e.getStackTraceString() ) ;
            pageRef = new PageReference('https://www.google.it');
            pageRef.setRedirect(true);
        }   
        return pageRef;
    }
    
}